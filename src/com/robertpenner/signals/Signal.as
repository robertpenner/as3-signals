package com.robertpenner.signals
{
	import flash.utils.Dictionary;
	import com.robertpenner.signals.IEvent;
	import com.robertpenner.signals.IEventBubbler;

	/**
	 * Signal dispatches events to multiple listeners.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://code.google.com/p/as3-signals/">http://code.google.com/p/as3-signals/</a>
	 */
	public class Signal implements ISignal
	{
		protected var _target:*;
		protected var _eventClass:Class;
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
				
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function Signal(target:*, eventClass:Class = null)
		{
			_target = target;
			_eventClass = eventClass;
			listeners = [];
			onceListeners = new Dictionary();
		}
		
		/** The current number of listeners for the signal. */
		public function get length():uint { return listeners.length; }
		
		/** The object that contains the signal. */
		public function get target():* { return _target; }
		
		/**
		 * An optional class reference that enables an event type check in dispatch().
		 */
		public function get eventClass():Class { return _eventClass; }
		
		/**
		 * Subscribes a listener for the signal.
		 * @param	listener A function with a single argument
		 * that matches the type of event dispatched by the signal.
		 */
		public function add(listener:Function):void
		{
			if (!listener.length) throw new ArgumentError('Missing argument in listener function.');
			if (listeners.indexOf(listener) >= 0) return; // Don't add same listener twice.
			listeners.push(listener);
		}
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called.
		 * @param	listener A function with a single argument
		 * that matches the type of event dispatched by the signal.
		 */
		public function addOnce(listener:Function):void
		{
			onceListeners[listener] = true;
			add(listener);
		}
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 */
		public function remove(listener:Function):void
		{
			listeners.splice(listeners.indexOf(listener), 1);
			delete onceListeners[listener];
		}
		
		/**
		 * Dispatches an object to the signal's listeners.
		 * @param	eventObject		Any object, but an IEvent will take advantage of targeting and bubbling.
		 * @throws	ArgumentError	Null argument passed to dispatch().
		 * @throws	TypeError		Incompatible event type passed to dispatch().
		 */
		public function dispatch(eventObject:Object):void
		{
			if (!eventObject)
				throw new ArgumentError('Null argument passed to dispatch().');
			
			if (_eventClass && !(eventObject is _eventClass))
				throw new TypeError('Incompatible event type passed to dispatch().');
				
			var event:IEvent = eventObject as IEvent;
			if (event)
			{
				if (!event.target) event.target = this.target;
				event.currentTarget = this.target;
				event.signal = this;
				// Bubble the event if desired and possible.
				if (!listeners.length && event.bubbles)
				{
					var bubbler:IEventBubbler = this.target.parent as IEventBubbler;
					if (bubbler) bubbler.onEventBubbled(event);
					return;
				}
			}
			if (!listeners.length) return; // exit early and avoid cloning array
			
			// Clone listeners array because add/remove may occur during the dispatch.
			for each (var listener:Function in listeners.concat())
			{
				if (onceListeners[listener]) remove(listener);
				listener(eventObject);
			}
		}
		
		/** Unsubscribes all listeners from the signal. */
		public function removeAll():void
		{
			listeners.length = 0;
		}
		
	}
}
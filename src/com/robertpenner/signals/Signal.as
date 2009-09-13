package com.robertpenner.signals
{
	import flash.utils.Dictionary;
	import com.robertpenner.signals.IEvent;
	import com.robertpenner.signals.IBubbleEventHandler;

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
		protected var _target:Object;
		protected var _eventClass:Class;
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
				
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function Signal(target:Object, eventClass:Class = null)
		{
			_target = target;
			_eventClass = eventClass;
			listeners = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listeners.length; }
		
		/** @inheritDoc */
		public function get target():Object { return _target; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):void
		{
			if (eventClass && !listener.length)
				throw new ArgumentError('Listener must declare at least 1 argument when eventClass is specified.');
			if (listeners.indexOf(listener) >= 0) return; // Don't add same listener twice.
			listeners.push(listener);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):void
		{
			add(listener); // call this first in case it throws an error
			onceListeners[listener] = true;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			listeners.splice(listeners.indexOf(listener), 1);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			listeners.length = 0;
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function dispatch(eventObject:Object = null):void
		{
			if (_eventClass && !(eventObject is _eventClass))
				throw new ArgumentError('Event object '+eventObject+' is not an instance of '+_eventClass+'.');

			var event:IEvent = eventObject as IEvent;
			if (event)
			{
				//TODO: figure out when the event should be cloned
				if (!event.target) event.target = this.target; // write-once
				event.currentTarget = this.target;
				event.signal = this;
			}
				
			//// Send eventObject to each listener.
			if (listeners.length)
			{
				// Clone listeners array because add/remove may occur during the dispatch.
				//TODO: test performance of for each vs. for
				for each (var listener:Function in listeners.concat())
				{
					if (onceListeners[listener]) remove(listener);
					//TODO: Maybe put this conditional outside the loop.
					eventObject ? listener(eventObject) : listener();
				}
			}
				
			if (!event || !event.bubbles) return;

			//// Bubble the event as far as possible.
			var currentTarget:Object = this.target;
			while ( currentTarget && currentTarget.hasOwnProperty("parent")
					&& (currentTarget = currentTarget.parent) )
			{
				if (currentTarget is IBubbleEventHandler)
				{
					IBubbleEventHandler(currentTarget).onEventBubbled(event);
					currentTarget = null;
				}
			}
		}
	}
}
package com.robertpenner.signals
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;
	import com.robertpenner.signals.IEvent;
	import com.robertpenner.signals.IEventBubbler;

	/**
	 * The NativeSignal class uses an ISignal interface as a facade for an IEventDispatcher.
	 */
	public class NativeSignal implements ISignal
	{
		protected var _target:IEventDispatcher;
		protected var _name:String;
		protected var _eventClass:Class;
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
				
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function NativeSignal(target:IEventDispatcher, name:String, eventClass:Class = null)
		{
			_target = IEventDispatcher(target);
			_name = name;
			_eventClass = eventClass;
			listeners = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get length():uint { return listeners.length; }
		
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
			_target.addEventListener(_name, listener);
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
			_target.removeEventListener(_name, listener);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			for (var i:int = listeners.length-1; i >= 0; i--)
			{
				remove(listeners[i]);
			}
		}
		
		/** @inheritDoc */
		public function dispatch(eventObject:Object = null):void
		{
			var event:Event = Event(eventObject);
			if (_eventClass && !(event is _eventClass))
				throw new ArgumentError('Event object '+eventObject+' is not an instance of '+_eventClass+'.');

			_target.dispatchEvent(event);
		}
	}
}
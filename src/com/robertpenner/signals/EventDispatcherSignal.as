package com.robertpenner.signals
{
	import com.robertpenner.signals.Signal;
	import flash.events.IEventDispatcher;

	/**
	 * The EventDispatcherSignal class is used to relay events from an IEventDispatcher
	 * to signal listeners.
	 */
	public class EventDispatcherSignal extends Signal implements ISignal
	{
		protected var _name:String;

		/**
		 * Creates a new EventDispatcherSignal instance to relay events from an IEventDispatcher.
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	name	The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function EventDispatcherSignal(target:IEventDispatcher, name:String, eventClass:Class = null)
		{
			super(target, eventClass);
			_name = name;
		}
		
		/** @inheritDoc */
		override public function add(listener:Function):void
		{
			super.add(listener);
			IEventDispatcher(target).addEventListener(_name, dispatch);
		}
		
		/** @inheritDoc */
		override public function remove(listener:Function):void
		{
			super.remove(listener);
			IEventDispatcher(target).removeEventListener(_name, dispatch);
		}
		
	}
}

package com.robertpenner.signals
{
	import com.robertpenner.signals.Signal;
	import flash.events.IEventDispatcher;

	/**
	 * The NativeRelaySignal class is used to relay events from an IEventDispatcher
	 * to signal listeners.
	 */
	public class NativeRelaySignal extends Signal implements ISignal
	{
		protected var _name:String;

		/**
		 * Creates a new NativeRelaySignal instance to relay events from an IEventDispatcher.
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	name	The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function NativeRelaySignal(target:IEventDispatcher, name:String, eventClass:Class = null)
		{
			super(target, eventClass);
			_name = name;
		}
		
		/** @inheritDoc */
		override public function add(listener:Function):void
		{
			var prevListenerCount:uint = listeners.length;
			// Try to add first because it may throw an exception.
			super.add(listener);
			// Account for cases where the same listener is added twice.
			if (prevListenerCount == 0 && listeners.length == 1)
				IEventDispatcher(target).addEventListener(_name, dispatch);
		}
		
		/** @inheritDoc */
		override public function remove(listener:Function):void
		{
			var prevListenerCount:uint = listeners.length;
			super.remove(listener);
			if (prevListenerCount == 1 && listeners.length == 0)
				IEventDispatcher(target).removeEventListener(_name, dispatch);
		}
		
	}
}

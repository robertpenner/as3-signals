package org.osflash.signals.natives
{
	import org.osflash.signals.DeluxeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The NativeRelaySignal class is used to relay events from an IEventDispatcher
	 * to listeners.
	 * The difference as compared to NativeSignal is that
	 * NativeRelaySignal has its own dispatching code,
	 * whereas NativeSignal uses the IEventDispatcher to dispatch.
	 */
	public class NativeRelaySignal extends DeluxeSignal
	{
		protected var _eventType:String;

		/**
		 * Creates a new NativeRelaySignal instance to relay events from an IEventDispatcher.
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	name	The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 * Because the target is an IEventDispatcher,
		 * eventClass needs to be flash.events.Event or a subclass of it.
		 */
		public function NativeRelaySignal(target:IEventDispatcher, eventType:String, eventClass:Class = null)
		{
			super(target, eventClass || Event);
			_eventType = eventType;
		}
		
		/** @inheritDoc */
		override public function add(listener:Function, priority:int = 0):void
		{
			var prevListenerCount:uint = listenerBoxes.length;
			// Try to add first because it may throw an exception.
			super.add(listener);
			// Account for cases where the same listener is added twice.
			if (prevListenerCount == 0 && listenerBoxes.length == 1)
				IEventDispatcher(_target).addEventListener(_eventType, dispatch, false, priority);
		}
		
		/** @inheritDoc */
		override public function addOnce(listener:Function, priority:int = 0):void
		{
			var prevListenerCount:uint = listenerBoxes.length;
			// Try to add first because it may throw an exception.
			super.addOnce(listener);
			// Account for cases where the same listener is added twice.
			if (prevListenerCount == 0 && listenerBoxes.length == 1)
				IEventDispatcher(_target).addEventListener(_eventType, dispatch, false, priority);
		}
		
		/** @inheritDoc */
		override public function remove(listener:Function):void
		{
			var prevListenerCount:uint = listenerBoxes.length;
			super.remove(listener);
			if (prevListenerCount == 1 && listenerBoxes.length == 0)
				IEventDispatcher(_target).removeEventListener(_eventType, dispatch);
		}
		
	}
}

package org.osflash.signals.relaxed.natives
{
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.ISlot;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.osflash.signals.relaxed.RelaxedStateController;
	
	/**
	 * The RelaxedNativeRelaySignal class is used to relay events from an IEventDispatcher
	 * to listeners.
	 * The difference as compared to NativeSignal is that
	 * NativeRelaySignal has its own dispatching code,
	 * whereas NativeSignal uses the IEventDispatcher to dispatch.
	 */
	public class RelaxedNativeRelaySignal extends NativeRelaySignal
	{
		/**
		 * Creates a new RelaxedNativeRelaySignal instance to relay events from an IEventDispatcher.
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType	The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 * Because the target is an IEventDispatcher,
		 * eventClass needs to be flash.events.Event or a subclass of it.
		 */
		public function RelaxedNativeRelaySignal(target:IEventDispatcher, eventType:String, eventClass:Class=null)
		{
			super(target, eventType, eventClass);
			_stateController = new RelaxedStateController();
			target.addEventListener( eventType, _handleEvent, false, 0, true );
		}
		
		protected var _stateController : RelaxedStateController;
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		override public function addOnceWithPriority(listener:Function, priority:int=0):ISlot
		{
			return _stateController.handleSlot( super.addOnceWithPriority( listener, priority ) );
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		override public function addWithPriority(listener:Function, priority:int=0):ISlot
		{
			return _stateController.handleSlot( super.addWithPriority( listener, priority ) );
		}
		
		private function _handleEvent( ...valueObjects ):void
		{
			_stateController.dispatchedValueObjects = valueObjects;
			_stateController.hasBeenDispatched = true;
		}
	
	}
}
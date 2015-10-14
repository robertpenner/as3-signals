package org.osflash.signals.relaxed.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.ISlot;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.relaxed.RelaxedStateController;
	
	/** 
	 * Allows the eventClass to be set in MXML, e.g.
	 * <natives:NativeSignal id="clicked" eventType="click" target="{this}">{MouseEvent}</natives:NativeSignal>
	 */
	[DefaultProperty("eventClass")]	
	
	/**
	 * The RelaxedNativeSignal class provides a strongly-typed facade for an IEventDispatcher.
	 * A NativeSignal is essentially a mini-dispatcher locked to a specific event type and class.
	 * It can become part of an interface.
	 */
	public class RelaxedNativeSignal extends NativeSignal
	{
		/**
		 * Creates a RelaxedNativeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object on whose behalf the signal is dispatching events.
		 * @param	eventType The type of Event permitted to be dispatched from this signal. Corresponds to Event.type.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch(). Defaults to flash.events.Event if omitted.
		 */
		public function RelaxedNativeSignal(target:IEventDispatcher=null, eventType:String="", eventClass:Class=null)
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
package org.osflash.signals.relaxed.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.ISlot;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.relaxed.RelaxedStateController;
	
	/**
	 * <p>
	 * The RelaxedNativeMappedSignal class is used to map/transform a native Event, 
	 * relayed from an IEventDispatcher, into other forms of data, 
	 * which are dispatched to all listeners.
	 * </p>
	 * <p>This can be used to form a border where native flash Events do not cross.</p>
	 */
	public class RelaxedNativeMappedSignal extends NativeMappedSignal
	{
		/**
		 * Creates a new RelaxedNativeMappedSignal instance to map/transform a native Event, 
		 * relayed from an IEventDispatcher, into other forms of data, 
		 * which are dispatched to all listeners.
		 * 
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param 	eventClass An optional class reference that enables an event type check in dispatch().
		 * @param	mappedTypes an optional list of types that enables the checking of the types mapped from an Event. 
		 */
		public function RelaxedNativeMappedSignal(target:IEventDispatcher, eventType:String, eventClass:Class=null, ...mappedTypes)
		{
			// Cannot use super.apply(null, mappedTypes), so allow the subclass to call super(mappedTypes).
			mappedTypes = (mappedTypes.length == 1 && mappedTypes[0] is Array) ? mappedTypes[0]:mappedTypes;
			super(target, eventType, eventClass, mappedTypes);
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
		
		private function _handleEvent( event : Event ):void
		{
			_stateController.dispatchedValueObjects = mapEvent( event );
			_stateController.hasBeenDispatched = true;
		}
		
		
		
		
	}
}
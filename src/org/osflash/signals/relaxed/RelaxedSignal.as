package org.osflash.signals.relaxed
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Signal;
	
	public class RelaxedSignal extends Signal implements ISignal
	{
		public function RelaxedSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			super(valueClasses);
			_stateController = new RelaxedStateController();
		}
		
		protected var _stateController : RelaxedStateController;
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function add(listener:Function):ISlot
		{
			return _stateController.handleSlot( super.add( listener ) );
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function addOnce(listener:Function):ISlot
		{
			return _stateController.handleSlot( super.addOnce( listener ) );
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Incorrect number of arguments.
		 * @throws ArgumentError <code>ArgumentError</code>: Value object is not an instance of the appropriate valueClasses Class.
		 */
		override public function dispatch(...valueObjects):void
		{
			_stateController.dispatchedValueObjects = valueObjects;
			_stateController.hasBeenDispatched = true;
			super.dispatch(valueObjects);
		}
		
	}
}
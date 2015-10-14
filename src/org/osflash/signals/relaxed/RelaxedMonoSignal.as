package org.osflash.signals.relaxed
{
	import org.osflash.signals.ISlot;
	import org.osflash.signals.MonoSignal;
	
	/** 
	 * Allows the valueClasses to be set in MXML, e.g.
	 * <signals:Signal id="nameChanged">{[String, uint]}</signals:Signal>
	 */
	[DefaultProperty("valueClasses")]	
	
	/**
	 * A MonoSignal can have only one listener.
	 */
	public class RelaxedMonoSignal extends MonoSignal
	{
		/**
		 * Creates a RelaxedMonoSignal instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function RelaxedMonoSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			super(valueClasses);
			_stateController = new RelaxedStateController();
		}
		protected var _stateController : RelaxedStateController;
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add or addOnce with a listener already added, remove the current listener first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function add(listener:Function):ISlot
		{
			return _stateController.handleSlot( super.add( listener ) );
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add or addOnce with a listener already added, remove the current listener first.
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
			super.dispatch.apply( this, valueObjects);
		}		
	}
}
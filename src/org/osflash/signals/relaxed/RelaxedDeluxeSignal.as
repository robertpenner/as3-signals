package org.osflash.signals.relaxed
{
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.ISlot;
	
	/** 
	 * Allows the valueClasses to be set in MXML, e.g.
	 * <signals:Signal id="nameChanged">{[String, uint]}</signals:Signal>
	 */
	[DefaultProperty("valueClasses")]
	/**
	 * Signal dispatches events to multiple listeners.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://github.com/robertpenner/as3-signals/">http://github.com/robertpenner/as3-signals/</a>
	 */
	public class RelaxedDeluxeSignal extends DeluxeSignal
	{
		/**
		 * Creates a RelaxedDeluxeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new DeluxeSignal(this, String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function RelaxedDeluxeSignal(target:Object=null, ...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			super(target, valueClasses);
			_stateController = new RelaxedStateController();
		}
		
		protected var _stateController : RelaxedStateController;
		
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
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function addOnceWithPriority(listener:Function, priority:int=0):ISlot
		{
			return _stateController.handleSlot( super.addOnceWithPriority( listener, priority ) );
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function addWithPriority(listener:Function, priority:int=0):ISlot
		{
			return _stateController.handleSlot( super.addWithPriority( listener, priority ) );
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
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		override public function add(listener:Function):ISlot
		{
			return _stateController.handleSlot( super.add( listener ) );
		}
	}
}
package org.osflash.signals
{
    import flash.errors.IllegalOperationError;
    
    import org.osflash.signals.ISlot;
    import org.osflash.signals.OnceSignal;

    public class Promise extends OnceSignal
    {
        private var _isDispatched:Boolean;
        private var valueObjects:Array;

		/**
		 * Creates a Promise instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: In AS3, subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function Promise(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			
			super(valueClasses);
		}
		
        /** @inheritDoc */
        override public function addOnce(listener:Function):ISlot
        {
            var slot:ISlot = super.addOnce(listener);
            if (_isDispatched)
            {
                slot.execute(valueObjects);
                slot.remove();
            }

            return slot;
        }

        /**
         * @inheritDoc
         * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot dispatch() a Promise more than once
         */
        override public function dispatch(...valueObjects):void
        {
            if (_isDispatched)
            {
                throw new IllegalOperationError("You cannot dispatch() a Promise more than once");
            }
            else
            {
                _isDispatched = true;
                this.valueObjects = valueObjects;
                super.dispatch.apply(this, valueObjects);
            }
        }
		
		public function get isDispatched():Boolean
		{
			return _isDispatched;
		}
    }
}

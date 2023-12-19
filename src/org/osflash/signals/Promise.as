package org.osflash.signals
{
    import flash.errors.IllegalOperationError;

    import org.osflash.signals.ISlot;
    import org.osflash.signals.OnceSignal;

    public class Promise extends OnceSignal implements IPriorityOnceSignal
    {
        private var _isDispatched:Boolean;
        private var valueObjects:Array;

        /** Whether to ignore any subsequent calls to <code>dispatch()</code>. By default, subsequent calls will throw an error. */
        public var ignoreSubsequentDipatches:Boolean = false;

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
            valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;

            super(valueClasses);
        }

        /** @inheritDoc */
        override public function addOnce(listener:Function):ISlot
        {
            return addOnceWithPriority(listener);
        }

        public function addOnceWithPriority(listener:Function, priority:int = 0):ISlot 
		{
			var slot:ISlot = registerListenerWithPriority(listener, true, priority);

            if (_isDispatched)
            {
                slot.execute(valueObjects);
                slot.remove();
            }

            return slot;
		}

        override protected function registerListener(listener:Function, once:Boolean = false):ISlot
        {
            return registerListenerWithPriority(listener, once);
        }

        protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISlot
        {
            if (registrationPossible(listener, once))
            {
                const slot:ISlot = new Slot(listener, this, once, priority);
                slots = slots.insertWithPriority(slot);
                return slot;
            }

            return slots.find(listener);
        }

        /**
         * @inheritDoc
         * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot dispatch() a Promise more than once
         */
        override public function dispatch(...valueObjects):void
        {
            if (_isDispatched)
            {
                if (!ignoreSubsequentDipatches)
                {
                    throw new IllegalOperationError("You cannot dispatch() a Promise more than once");
                }
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

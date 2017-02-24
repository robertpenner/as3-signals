package org.osflash.signals
{
    import flash.errors.IllegalOperationError;
    
    import org.osflash.signals.ISlot;
    import org.osflash.signals.OnceSignal;

    public class Promise extends OnceSignal
    {
        private var _isDispatched:Boolean;
        private var valueObjects:Array;

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

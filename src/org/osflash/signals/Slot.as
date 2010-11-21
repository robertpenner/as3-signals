package org.osflash.signals 
{
    /**
     * The Slot class represents a signal slot.
     *
     * @author Robert Penner
     */
	internal final class Slot
	{
		/**
		 * The pseudo-private next Slot in the pool of Slot objects.
		 * @private
		 */
		internal var _nextInPool: Slot;

		/**
		 * The pseudo-private signal variable.
		 * @private
		 */
		internal var _signal:ISignal;

		/**
		 * The listener associated with this slot.
		 */
		public var listener:Function;

		/**
		 * Whether or not this listener is only executed once.
		 */
		public var once:Boolean;

		/**
		 * The priority of this slot.
		 */
		public var priority:int;

		/**
		 * The Slot constructor cannot be executed. Use SlotPool.create instead.
		 *
		 * @see org.osflash.signals.SlotPool#create
		 * @throws Error An error is thrown if the constructor is invoked outside of SlotPool.
		 * @private
		 */
		public function Slot()
		{
			if (!SlotPool.constructorAllowed)
			{
				throw new Error('Slot is a pooled class. Use the SlotPool.create() method instead.');
			}
		}
		
		public function execute(valueObjects:Array):void
		{
			if (once) _signal.remove(listener);
			listener.apply(null, valueObjects);
		}
		
		public function execute0():void
		{
			if (once) _signal.remove(listener);
			listener();
		}
		
		public function execute1(value1:Object):void
		{
			if (once) _signal.remove(listener);
			listener(value1);
		}
		
		public function execute2(value1:Object, value2:Object):void
		{
			if (once) _signal.remove(listener);
			listener(value1, value2);
		}

		public function toString():String
		{
			return "Slot[listener: "+listener+", once: "+once+", priority: "+priority+"]";
		}
	}
}
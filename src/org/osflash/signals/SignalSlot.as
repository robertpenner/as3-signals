package org.osflash.signals 
{
    /**
     * The SignalSlot class represents a signal slot.
     *
     * @author Robert Penner
     */
	internal final class SignalSlot implements ISignalSlot
	{
		//
		// Note: We define all properties as internal here so we
		// can access them without the overhead of an implicit getter.
		//

		/**
		 * The pseudo-private next SignalSlot in the pool of SignalSlot objects.
		 * @private
		 */
		internal var _nextInPool: SignalSlot;

		/**
		 * The pseudo-private signal variable.
		 * @private
		 */
		internal var _signal:ISignal;

		/**
		 * The listener associated with this slot.
		 * @private
		 */
		internal var _listener:Function;

		/**
		 * Whether or not this listener is only executed
		 * @private
		 */
		internal var _isOnce:Boolean;

		/**
		 * The priority of this slot.
		 * @private
		 */
		internal var _priority:int;

		/**
		 * The SignalSlot constructor cannot be executed. Use SlotPool.create instead.
		 *
		 * @see org.osflash.signals.SlotPool#create()
		 * @throws Error An error is thrown if the constructor is invoked outside of SlotPool.
		 * @private
		 */
		public function SignalSlot()
		{
			if (!SlotPool.constructorAllowed)
			{
				throw new Error('SignalSlot is a pooled class. Use the SlotPool.create() method instead.');
			}
		}

		/**
		 * @inheritDoc
		 */
		public function execute(valueObjects:Array):void
		{
			if (_isOnce) _signal.remove(_listener);
			_listener.apply(null, valueObjects);
		}

		/**
		 * @inheritDoc
		 */
		public function execute0():void
		{
			if (_isOnce) _signal.remove(_listener);
			_listener();
		}

		/**
		 * @inheritDoc
		 */
		public function execute1(value1:Object):void
		{
			if (_isOnce) _signal.remove(_listener);
			_listener(value1);
		}

		/**
		 * @inheritDoc
		 */
		public function execute2(value1:Object, value2:Object):void
		{
			if (_isOnce) _signal.remove(_listener);
			_listener(value1, value2);
		}

		/**
		 * @inheritDoc
		 */
		public function get listener():Function
		{
			return _listener;
		}

		/**
		 * @inheritDoc
		 */
		public function get isOnce():Boolean
		{
			return _isOnce;
		}

		/**
		 * @inheritDoc
		 */
		public function get priority():int
		{
			return _priority;
		}

		/**
		 * Creates and returns the string representation of the current object.
		 *
		 * @return The string representation of the current object.
		 */
		public function toString():String
		{
			return "SignalSlot[listener: "+_listener+", once: "+_isOnce+", priority: "+_priority+"]";
		}
	}
}
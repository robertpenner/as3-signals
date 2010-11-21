package org.osflash.signals {
	import flash.utils.getQualifiedClassName;

	/**
	 * The SlotPool class represents a pool of Slot objects.
	 *
	 * @author Joa Ebert
	 */
	internal final class SlotPool
	{
		/**
		 * The growth rate of the pool.
		 */
		private static const POOL_GROWTH_RATE: int = 0x10;

		/**
		 * Whether or not if it is allowed to call the constructor of Slot.
		 * @private
		 */
		internal static var constructorAllowed:Boolean;

		/**
		 * The number of available objects in the pool.
		 */
		private static var availableInPool:int;

		/**
		 * A single linked list of Slot objects.
		 */
		private static var pool:Slot;

		/**
		 * Returns a Slot object from the pool.
		 *
		 * <p>Creates a series of new Slot objects if the pool is out of object.</p>
		 *
		 * @param listener The listener associated with the slot.
		 * @param once Whether or not the listener should be executed only once.
		 * @param signal The signal associated with the slot.
		 * @param priority The priority of the slot.
		 * @return A slot object.
		 */
		public static function create(listener:Function, once:Boolean = false, signal:ISignal = null, priority:int = 0):Slot
		{
			var pooledObject:Slot;

			if (0 == availableInPool)
			{
				var n:int = POOL_GROWTH_RATE + 1;

				try
				{
					constructorAllowed = true;

					while (--n != 0)
					{
						pooledObject = new Slot();
						pooledObject._nextInPool = pool;
						pool = pooledObject;
					}
				}
				finally
				{
					constructorAllowed = false;
				}

				availableInPool += POOL_GROWTH_RATE;
			}

			pooledObject = pool;
			pool = pooledObject._nextInPool;
			--availableInPool;

			pooledObject.listener = listener;
			pooledObject.once = once;
			pooledObject.priority = priority;
			pooledObject._signal = signal;

			return pooledObject;
		}

		internal static function release(slot:Slot):void
		{
			slot.listener = null;
			slot._signal = null;
			slot._nextInPool = pool;
			pool = slot;

			++availableInPool;
		}
	}
}

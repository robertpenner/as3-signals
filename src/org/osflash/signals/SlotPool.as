package org.osflash.signals {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The SlotPool class represents a pool of SignalSlot objects.
	 *
	 * <p>SlotPool is responsible for creating and releasing
	 * SignalSlot objects. A slot object is usually released when
	 * <code>SignalSlot.remove</code> is called. Because of the internal wiring
	 * of signals the SlotPool delays the release of SignalSlot
	 * objects until an <code>Event.EXIT_FRAME</code> event occurs.</p>
	 *
	 * @author Joa Ebert
	 * @private
	 */
	internal final class SlotPool
	{
		/**
		 * An IEventDispatcher capable of dispatching <code>Event.EXIT_FRAME</code>.
		 * @private
		 */
		private static const EXIT_FRAME_PROVIDER: IEventDispatcher = new Shape();

		/**
		 * The growth rate of the pool.
		 * @private
		 */
		public static const POOL_GROWTH_RATE: int = 0x10;

		/**
		 * Whether or not if it is allowed to call the constructor of SignalSlot.
		 * @private
		 */
		public static var constructorAllowed:Boolean;

		/**
		 * The private backing variable for the <code>numAvailable</code> property.
		 * @private
		 */
		private static var _numAvailable:int;

		/**
		 * The list of available SignalSlot objects.
		 * @private
		 */
		private static var pooledSlots:SignalSlot;

		/**
		 * The list of dead SignalSlot objects.
		 *
		 * Dead slot objects will be put back into the pool when
		 * <code>releaseDeadSlots.</code> is called.
		 *
		 * @see org.osflash.signals.SlotPool#releaseDeadSlots()
		 * @private
		 */
		private static var deadSlots:SignalSlot;

		/**
		 * Whether or not the SlotPool is listening for <code>Event.EXIT_FRAME</code>.
		 */
		private static var listensForExitFrame: Boolean;

		/**
		 * Returns a SignalSlot object from the pool.
		 *
		 * <p>Creates a series of new SignalSlot objects if the pool is out of object.</p>
		 *
		 * @param listener The listener associated with the slot.
		 * @param once Whether or not the listener should be executed only once.
		 * @param signal The signal associated with the slot.
		 * @param priority The priority of the slot.
		 * @return A slot object.
		 */
		public static function create(listener:Function, once:Boolean = false, signal:ISignal = null, priority:int = 0):SignalSlot
		{
			var slot:SignalSlot;

			if (0 == _numAvailable)
			{
				var n:int = POOL_GROWTH_RATE + 1;

				try
				{
					constructorAllowed = true;

					while (--n != 0)
					{
						slot = new SignalSlot();
						slot._nextInPool = pooledSlots;
						pooledSlots = slot;
					}
				}
				finally
				{
					constructorAllowed = false;
				}

				_numAvailable += POOL_GROWTH_RATE;
			}

			slot = pooledSlots;
			pooledSlots = slot._nextInPool;
			--_numAvailable;

			slot._listener = listener;
			slot._isOnce = once;
			slot._priority = priority;
			slot._signal = signal;

			return slot;
		}

		/**
		 * Marks a SignalSlot dead.
		 *
		 * The internal references of the SignalSlot object will be released
		 * when the next Event.EXIT_FRAME event occurs.
		 *
		 * @param slot The slot which is no longer being used.
		 */
		public static function markDead(slot:SignalSlot):void
		{
			slot._nextInPool = deadSlots;
			deadSlots = slot;

			if(!listensForExitFrame) {
				EXIT_FRAME_PROVIDER.addEventListener(Event.EXIT_FRAME, onExitFrame);
				listensForExitFrame = true;
			}
		}

		/**
		 * Listener for native <code>Event.EXIT_FRAME</code>.
		 *
		 * This listener will invoke the <code>releaseDeadSlots</code> method.
		 *
		 * @param event The native event dispatched by the Flash Player.
		 */
		private static function onExitFrame(event:Event):void
		{
			releaseDeadSlots();

			EXIT_FRAME_PROVIDER.removeEventListener(Event.EXIT_FRAME, onExitFrame);
			listensForExitFrame = false;
		}

		/**
		 * Releases all dead slots and puts them back into the pool.
		 */
		public static function releaseDeadSlots():void
		{
			var nextSlot: SignalSlot = deadSlots;

			while(nextSlot)
			{
				var slot: SignalSlot = nextSlot;
				nextSlot = slot._nextInPool;

				slot._listener = null;
				slot._signal = null;
				slot._nextInPool = pooledSlots;
				pooledSlots = slot;

				++_numAvailable;
			}

			deadSlots = null;
		}

		/**
		 * Resets the state of the SlotPool.
		 * @private
		 */
		public static function resetState():void
		{
			resetAll(deadSlots);
			resetAll(pooledSlots);

			deadSlots = null;
			pooledSlots = null;
			_numAvailable = 0;

			if(listensForExitFrame)
			{
				EXIT_FRAME_PROVIDER.removeEventListener(Event.EXIT_FRAME, onExitFrame);
				listensForExitFrame = false;
			}

			constructorAllowed = false;
		}

		/**
		 * Resets a given list of SignalSlot objects.
		 *
		 * @param list The linked list of slot objects to reset.
		 * @private
		 */
		private static function resetAll(list:SignalSlot):void {
			var nextSlot:SignalSlot = list;

			while(nextSlot)
			{
				var slot:SignalSlot = nextSlot;
				nextSlot = slot._nextInPool;

				slot._listener = null;
				slot._signal = null;
				slot._nextInPool = null;
			}
		}

		/**
		 * The number of available objects in the pool.
		 */
		public static function get numAvailable(): int
		{
			return _numAvailable;
		}
	}
}

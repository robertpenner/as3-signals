package org.osflash.signals {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.osmf.metadata.IFacet;

	/**
	 * The SlotPool class represents a pool of Slot objects.
	 *
	 * <p>SlotPool is responsible for creating and releasing
	 * Slot objects. A slot object is usually released when
	 * <code>Slot.remove</code> is called. Because of the internal wiring
	 * of signals the SlotPool delays the release of Slot
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
		 * Whether or not if it is allowed to call the constructor of Slot.
		 * @private
		 */
		public static var constructorAllowed:Boolean;

		/**
		 * The private backing variable for the <code>numAvailable</code> property.
		 * @private
		 */
		private static var _numAvailable:int;

		/**
		 * The list of available Slot objects.
		 * @private
		 */
		private static var pooledSlots:Slot;

		/**
		 * The list of dead Slot objects.
		 *
		 * Dead slot objects will be put back into the pool when
		 * <code>releaseDeadSlots.</code> is called.
		 *
		 * @see #releaseDeadSlots
		 * @private
		 */
		private static var deadSlots:Slot;

		/**
		 * Whether or not the SlotPool is listening for <code>Event.EXIT_FRAME</code>.
		 */
		private static var listensForExitFrame: Boolean;

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
			var slot:Slot;

			if (0 == _numAvailable)
			{
				var n:int = POOL_GROWTH_RATE + 1;

				try
				{
					constructorAllowed = true;

					while (--n != 0)
					{
						slot = new Slot();
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

			slot.listener = listener;
			slot.once = once;
			slot.priority = priority;
			slot._signal = signal;

			return slot;
		}

		/**
		 * Marks a Slot dead.
		 *
		 * The internal references of the Slot object will be released
		 * when the next Event.EXIT_FRAME event occurs.
		 *
		 * @param slot The slot which is no longer being used.
		 */
		public static function markDead(slot:Slot):void
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
			var nextSlot: Slot = deadSlots;

			while(nextSlot)
			{
				var slot: Slot = nextSlot;
				nextSlot = slot._nextInPool;

				slot.listener = null;
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
		 * Resets a given list of Slot objects.
		 *
		 * @param list The linked list of slot objects to reset.
		 * @private
		 */
		private static function resetAll(list:Slot):void {
			var nextSlot:Slot = list;

			while(nextSlot)
			{
				var slot:Slot = nextSlot;
				nextSlot = slot._nextInPool;

				slot.listener = null;
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

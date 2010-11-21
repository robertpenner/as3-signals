package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import flash.utils.setTimeout;

	public final class SlotPoolTest
	{
		//todo how to use IAsync correct to continue after EXIT_FRAME?

		[Inject]
	    public var async:IAsync;

		[After]
		public function tearDown():void
		{
			SlotPool.resetState();
		}

		[Test]
		public function resetState_sets_numAvailable_to_zero():void
		{
			SlotPool.create(null);
			SlotPool.resetState();
			assertEquals(0, SlotPool.numAvailable);
		}

		[Test]
		public function available_objects_is_default_growth_rate():void
		{
			var slot: Slot = SlotPool.create(null);

			//we add one since one slot has been consumed
			assertEquals(SlotPool.POOL_GROWTH_RATE, SlotPool.numAvailable + 1);
		}

		[Test]
		public function dead_slot_is_released():void
		{
			SlotPool.markDead(SlotPool.create(null));

			setTimeout(async.add(function():void{
				 assertEquals(SlotPool.POOL_GROWTH_RATE, SlotPool.numAvailable);
		 	}, 50), 1);
		}

		[Test]
		public function markDead_does_not_destroy_listener_before_timeout():void
		{
			var listener: Function = function():void {};
			var slot: Slot = SlotPool.create(listener);

			SlotPool.markDead(slot);

			assertEquals(slot.listener, listener);
		}

		[Test]
		public function markDead_destroys_listener_after_timeout():void
		{
			var listener: Function = function():void {};
			var slot: Slot = SlotPool.create(listener);

			SlotPool.markDead(slot);

			setTimeout(async.add(function():void{
				 assertNull(slot.listener);
		 	}, 50), 1);
		}

		[Test]
		public function pool_grows_and_releases_objects_correct():void
		{
			var n: int = SlotPool.POOL_GROWTH_RATE << 1;

			for(var i: int = 0; i < n; i++) {
				SlotPool.markDead(SlotPool.create(null));
			}

			assertEquals(0, SlotPool.numAvailable);

			setTimeout(async.add(function():void{
				assertEquals(n, SlotPool.numAvailable);
		 	}, 50), 1);
		}

		[Test]
		public function pool_grows_by_rate(): void
		{
			var n: int = SlotPool.POOL_GROWTH_RATE + 1;

			for(var i: int = 0; i < n; i++) {
				SlotPool.create(null);
			}

			//plus one since n + 1 have been removed
			assertEquals(SlotPool.POOL_GROWTH_RATE, SlotPool.numAvailable + 1);
		}

		[Test]
		public function pool_creates_slots_correct():void
		{
			var listener: Function = function():void{};
			var signal: ISignal = new Signal();
			var slot: Slot = SlotPool.create(listener, true, signal, 1);

			assertEquals(1, slot.priority);
			assertTrue(slot.once);
			assertEquals(signal, slot._signal);
			assertEquals(listener,  slot.listener);
		}
	}
}

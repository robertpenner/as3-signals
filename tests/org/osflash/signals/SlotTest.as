package org.osflash.signals
{
	import org.osflash.signals.events.GenericEvent;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SlotTest extends ISlotTestBase
	{

		[Before]
		public function setUp():void
		{
			signal = new Signal();
		}
		
		[Test]
		public function add_listener_pause_then_resume_on_slot_should_dispatch():void
		{
			var slot:ISlot = signal.add(async.add(checkGenericEvent, 10));
			slot.enabled = false;
			slot.enabled = true;
			
			signal.dispatch(new GenericEvent());
		}
		
		[Test]
		public function addOnce_listener_pause_then_resume_on_slot_should_dispatch():void
		{
			var slot:ISlot = signal.addOnce(async.add(checkGenericEvent, 10));
			slot.enabled = false;
			slot.enabled = true;
			
			signal.dispatch(new GenericEvent());
		}
	}
}

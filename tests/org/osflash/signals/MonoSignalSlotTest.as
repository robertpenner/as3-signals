package org.osflash.signals
{
	import asunit.asserts.assertNull;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class MonoSignalSlotTest
	{
		[Inject]
	    public var async:IAsync;
	    
		public var completed:MonoSignal;
		
		[Before]
		public function setUp():void
		{
			completed = new MonoSignal();
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		
		protected function newEmptyHandler():Function
		{
			return function():void {};
		}
		
		protected function failIfCalled():void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_once_is_false():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.add(listener);
			
			assertTrue('Slot once is false', slot.once == false);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_priority_is_zero():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.add(listener);
			
			assertTrue('Slot priority is zero', slot.priority == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_slot_listener_is_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.add(listener);
			
			assertTrue('Slot listener is the same as the listener', slot.listener === listener);
		}
		
		//////
		
		[Test]
		public function add_listener_and_remove_using_slot():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			slot.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_pause_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = completed.add(failIfCalled);
			slot.enabled = false;
			
			completed.dispatch();
		}
		
		//////
		
		[Test]
		public function add_listener_pause_then_resume_on_slot_should_dispatch():void
		{
			var slot:ISlot = completed.add(async.add(checkGenericEvent, 10));
			slot.enabled = false;
			slot.enabled = true;
			
			completed.dispatch(new GenericEvent());
		}
		
		//////
		
		[Test]
		public function add_listener_switch_pause_and_resume_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = completed.add(failIfCalled);
			slot.enabled = false;
			slot.enabled = true;
			slot.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			slot.listener = newEmptyHandler();
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			slot.listener = failIfCalled;
			slot.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_change_listener_then_switch_back_and_then_should_dispatch():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			var listener:Function = slot.listener;
			
			slot.listener = failIfCalled;
			slot.listener = listener;
			
			completed.dispatch();
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function add_listener_then_set_listener_to_null_should_throw_ArgumentError():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			slot.listener = null;
		}
		
		//////
		
		[Test]
		public function add_listener_and_call_execute_on_slot_should_call_listener():void
		{
			var slot:ISlot = completed.add(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_once_is_true():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.addOnce(listener);
			
			assertTrue('Slot once is true', slot.once == true);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_priority_is_zero():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.addOnce(listener);
			
			assertTrue('Slot priority is zero', slot.priority == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_slot_listener_is_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = completed.addOnce(listener);
			
			assertTrue('Slot listener is the same as the listener', slot.listener === listener);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_remove_using_slot():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			slot.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_then_resume_on_slot_should_dispatch():void
		{
			var slot:ISlot = completed.addOnce(async.add(checkGenericEvent, 10));
			slot.enabled = false;
			slot.enabled = true;
			
			completed.dispatch(new GenericEvent());
		}
		
		//////
		
		[Test]
		public function addOnce_listener_switch_pause_and_resume_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = completed.addOnce(failIfCalled);
			slot.enabled = false;
			slot.enabled = true;
			slot.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			slot.listener = newEmptyHandler();
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			slot.listener = failIfCalled;
			slot.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			var listener:Function = slot.listener;
			
			slot.listener = failIfCalled;
			slot.listener = listener;
			
			completed.dispatch();
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			slot.listener = null;
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute_on_slot_should_call_listener():void
		{
			var slot:ISlot = completed.addOnce(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
	}
}

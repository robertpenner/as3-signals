package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertFalse;
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertNull;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ISlotTestBase
	{
		
		[Inject]
	    public var async:IAsync;
	    
		public var signal:ISignal;
		
		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		
		[Test]
		public function add_listener_pause_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = signal.add(failIfCalled);
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
				
		[Test]
		public function add_listener_switch_pause_and_resume_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = signal.add(failIfCalled);
			slot.enabled = false;
			slot.enabled = true;
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			slot.listener = newEmptyHandler();
			
			signal.dispatch(new Event('click'));		
		}
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			slot.listener = failIfCalled;
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		[Test]
		public function add_listener_then_change_listener_then_switch_back_and_then_should_dispatch():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			var listener:Function = slot.listener;
			
			slot.listener = failIfCalled;
			slot.listener = listener;
			
			signal.dispatch(new Event('click'));
		}
		
		[Test]
		public function addOnce_listener_pause_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = signal.addOnce(failIfCalled);
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
		
		[Test]
		public function addOnce_listener_switch_pause_and_resume_on_slot_should_not_dispatch():void
		{
			var slot:ISlot = signal.addOnce(failIfCalled);
			slot.enabled = false;
			slot.enabled = true;
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			slot.listener = newEmptyHandler();
			
			signal.dispatch(new Event('click'));		
		}
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			slot.listener = failIfCalled;
			slot.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
		
		[Test]
		public function addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			var listener:Function = slot.listener;
			
			slot.listener = failIfCalled;
			slot.listener = listener;
			
			signal.dispatch(new Event('click'));
		}
		
		[Test]
		public function add_listener_and_verify_once_is_false():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.add(listener);
			
			assertFalse('Slot once is false', slot.once);
		}
		
		[Test]
		public function add_listener_and_verify_priority_is_zero():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.add(listener);
			
			assertTrue('Slot priority is zero', slot.priority == 0);
		}
		
		[Test]
		public function add_listener_and_verify_slot_listener_is_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.add(listener);
			
			assertTrue('Slot listener is the same as the listener', slot.listener === listener);
		}
				
		[Test]
		public function add_same_listener_twice_and_verify_slots_are_the_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.add(listener);
			var slot1:ISlot = signal.add(listener);
			
			assertTrue('Slots are equal if they\'re they have the same listener', slot0 === slot1);
		}
		
		[Test]
		public function add_same_listener_twice_and_verify_slot_listeners_are_the_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.add(listener);
			var slot1:ISlot = signal.add(listener);
			
			assertTrue('Slot listener is the same as the listener', slot0.listener === slot1.listener);
		}
		
		[Test]
		public function add_listener_and_remove_using_slot():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			slot.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test]
		public function add_same_listener_twice_and_remove_using_slot_should_have_no_listeners():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.add(listener);
			signal.add(listener);
			
			slot0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test]
		public function add_lots_of_same_listener_and_remove_using_slot_should_have_no_listeners():void
		{
			var listener:Function = newEmptyHandler();
			for(var i:int = 0; i<100; i++)
			{
				var slot0:ISlot = signal.add(listener);
			}
			
			slot0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test(expects="ArgumentError")]
		public function add_listener_then_set_listener_to_null_should_throw_ArgumentError():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			slot.listener = null;
		}
				
		[Test]
		public function add_listener_and_call_execute_on_slot_should_call_listener():void
		{
			var slot:ISlot = signal.add(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		[Test]
		public function add_listener_twice_and_call_execute_on_slot_should_call_listener_and_not_on_signal_listeners():void
		{
			signal.add(failIfCalled);
			
			var slot:ISlot = signal.add(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		[Test]
		public function addOnce_listener_and_verify_once_is_true():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.addOnce(listener);
			
			assertTrue('Slot once is true', slot.once == true);
		}
		
		[Test]
		public function addOnce_listener_and_verify_priority_is_zero():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.addOnce(listener);
			
			assertTrue('Slot priority is zero', slot.priority == 0);
		}
		
		[Test]
		public function addOnce_listener_and_verify_slot_listener_is_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.addOnce(listener);
			
			assertTrue('Slot listener is the same as the listener', slot.listener === listener);
		}
				
		[Test]
		public function addOnce_same_listener_twice_and_verify_slots_are_the_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.addOnce(listener);
			var slot1:ISlot = signal.addOnce(listener);
			
			assertTrue('Slots are equal if they\'re they have the same listener', slot0 === slot1);
		}
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_slot_listeners_are_the_same():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.addOnce(listener);
			var slot1:ISlot = signal.addOnce(listener);
			
			assertTrue('Slot listener is the same as the listener', slot0.listener === slot1.listener);
		}
		
		[Test]
		public function addOnce_listener_and_remove_using_slot():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			slot.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test]
		public function addOnce_same_listener_twice_and_remove_using_slot_should_have_no_listeners():void
		{
			var listener:Function = newEmptyHandler();
			var slot0:ISlot = signal.addOnce(listener);
			signal.addOnce(listener);
			
			slot0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test]
		public function addOnce_lots_of_same_listener_and_remove_using_slot_should_have_no_listeners():void
		{
			var listener:Function = newEmptyHandler();
			for(var i:int = 0; i<100; i++)
			{
				var slot0:ISlot = signal.addOnce(listener);
			}
			
			slot0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		[Test(expects="ArgumentError")]
		public function addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			slot.listener = null;
		}
				
		[Test]
		public function addOnce_listener_and_call_execute_on_slot_should_call_listener():void
		{
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		[Test]
		public function addOnce_listener_twice_and_call_execute_on_slot_should_call_listener_and_not_on_signal_listeners():void
		{
			signal.addOnce(failIfCalled);
			
			var slot:ISlot = signal.addOnce(newEmptyHandler());
			slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		[Test]
		public function slot_params_are_null_when_created():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.add(listener);

			assertNull('params should be null', slot.params); 
		}

		[Test]
		public function slot_params_should_not_be_null_after_adding_array():void
		{
			var listener:Function = newEmptyHandler();
			var slot:ISlot = signal.add(listener);
			slot.params = [];

			assertNotNull('params should not be null', slot.params); 
		}

		[Test]
		public function slot_params_with_one_param_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertTrue(args[0] is int);
										assertEquals(args[0], 1234);
									};

			var slot:ISlot = signal.add(listener);
			slot.params = [1234];

			signal.dispatch(new MouseEvent('click'));
		}	

		[Test]
		public function slot_params_with_multiple_params_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
											
										assertTrue(args[0] is int);
										assertEquals(args[0], 12345);
										
										assertTrue(args[1] is String);
										assertEquals(args[1], 'text');
										
										assertTrue(args[2] is Sprite);
										assertEquals(args[2], slot.params[2]);
									};

			var slot:ISlot = signal.add(listener);
			slot.params = [12345, 'text', new Sprite()];

			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function slot_params_should_not_effect_other_slots():void
		{
			var listener0:Function = function(e:Event):void
									{ 
										assertNotNull(e);
										
										assertEquals(arguments.length, 1);
									};
			
			signal.add(listener0);
			
			var listener1:Function = function(e:Event):void
									{ 
										assertNotNull(e);
										
										assertEquals(arguments.length, 2);
										assertEquals(arguments[1], 123456);
									};
			
			var slot:ISlot = signal.add(listener1);
			slot.params = [123456];
			
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function verify_chaining_of_slot_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 1);
										assertEquals(args[0], 1234567);
									};
			
			signal.add(listener).params = [1234567];
						
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function verify_chaining_and_concat_of_slot_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 2);
										assertEquals(args[0], 12345678);
										assertEquals(args[1], 'text');
									};
			
			signal.add(listener).params = [12345678].concat(['text']);
						
			signal.dispatch(new MouseEvent('click'));
		}
		
		
		[Test]
		public function verify_chaining_and_pushing_on_to_slot_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 2);
										assertEquals(args[0], 123456789);
										assertEquals(args[1], 'text');
									};
			
			// This is ugly, but I put money on somebody will attempt to do this!
			var slots:ISlot;
			(slots = signal.add(listener)).params = [123456789];
			slots.params.push('text');
			
			signal.dispatch(new MouseEvent('click'));
		}
						
		////// UTILITY METHODS //////

		protected static function newEmptyHandler():Function
		{
			return function(e:* = null, ...args):void {};
		}
		
		protected static function failIfCalled(e:* = null):void
		{
			fail('This function should not have been called.');
		}
	}
}

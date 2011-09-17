package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertNull;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class MonoSignalTest
	{
		[Inject]
	    public var async:IAsync;
		
		public var signal:MonoSignal;
		
		[Before]
		public function setUp():void
		{
			signal = new MonoSignal();
		}

		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
		}
		
		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(0, signal.numListeners);
		}
				

		
		[Test]
		public function dispatch_should_pass_event_to_listener_but_not_set_signal_or_target_properties():void
		{
			signal.add(async.add(checkGenericEvent, 10));
			signal.dispatch(new GenericEvent());
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		

		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function add_two_listeners_should_throw_an_error():void
		{
			signal.add(checkGenericEvent);
			signal.add(checkGenericEvent);
		}
		

		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function add_one_hundred_listeners_should_throw_an_error():void
		{
			for(var i:int = 0; i<100; i++)
			{
				signal.add(checkGenericEvent);
			}
		}
		

		
		[Test]
		public function add_one_listeners_then_remove_it_then_add_another_listener():void
		{
			signal.add(failIfCalled);
			signal.remove(failIfCalled);
			signal.add(checkGenericEvent);
			signal.dispatch(new GenericEvent());
		}	
		

		
		[Test]
		public function addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			signal.addOnce(newEmptyHandler());
			signal.dispatch(new GenericEvent());
			assertEquals('there should be no listeners', 0, signal.numListeners);
		}
		

		
		[Test]
		public function add_listener_then_remove_then_dispatch_should_not_call_listener():void
		{
			signal.add(failIfCalled);
			signal.remove(failIfCalled);
			signal.dispatch(new GenericEvent());
		}
		
		private function failIfCalled(e:IEvent):void
		{
			fail('This event handler should not have been called.');
		}
		

		
		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			signal.add(newEmptyHandler());
			signal.remove(newEmptyHandler());
			assertEquals(1, signal.numListeners);
		}
		
		private function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		

		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function addOnce_same_listener_twice_should_throw_error():void
		{
			var func:Function = newEmptyHandler();
			signal.addOnce(func);
			signal.addOnce(func);
		}
		

		[Test]
		public function dispatch_non_IEvent_without_error():void
		{
			signal.addOnce(checkSprite);
			// Sprite doesn't have a target property,
			// so if the signal tried to set .target,
			// an error would be thrown and this test would fail.
			signal.dispatch(new Sprite());
		}
		
		private function checkSprite(sprite:Sprite):void
		{
			assertTrue(sprite is Sprite);
		}
		

		[Test]
		public function adding_a_listener_during_dispatch_should_not_call_it():void
		{
			signal.add(async.add(addListenerDuringDispatch, 10));
			signal.dispatch(new GenericEvent());
		}
		
		private function addListenerDuringDispatch():void
		{
			try
			{
				signal.add(failIfCalled);
			}
			catch(error:IllegalOperationError)
			{
				assertTrue('there should be 1 listener', signal.numListeners == 1);
			}
			catch(error:Error)
			{
				fail('This error should not have been thrown.');
			}
		}
		

		
		[Test]
		public function removed_listener_should_return_slot():void
		{
			var listener:Function = function():void{};
			var slot:ISlot = signal.add(listener);
			
			assertTrue("Slot is returned", slot == signal.remove(listener));
		}
		

		
		[Test]
		public function removed_listener_should_be_returned():void
		{
			var slot:ISlot = signal.add(function():void{});
			var listener:Function = slot.listener;
			
			assertTrue("Slot is returned", slot == signal.remove(listener));
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
			var listener:Function = function(...args):void
									{ 
										assertTrue(args[0] is int);
										assertEquals(args[0], 1234);
									};

			var slot:ISlot = signal.add(listener);
			slot.params = [1234];

			signal.dispatch();
		}	

		[Test]
		public function slot_params_with_multiple_params_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(...args):void
									{ 
										assertTrue(args[0] is int);
										assertEquals(args[0], 12345);
										
										assertTrue(args[1] is String);
										assertEquals(args[1], 'text');
										
										assertTrue(args[2] is Sprite);
										assertEquals(args[2], slot.params[2]);
									};

			var slot:ISlot = signal.add(listener);
			slot.params = [12345, 'text', new Sprite()];

			signal.dispatch();
		}
				
		[Test]
		public function verify_chaining_of_slot_params():void
		{
			var listener:Function = function(...args):void
									{ 
										assertEquals(args.length, 1);
										assertEquals(args[0], 1234567);
									};
			
			signal.add(listener).params = [1234567];
						
			signal.dispatch();
		}
		
		[Test]
		public function verify_chaining_and_concat_of_slot_params():void
		{
			var listener:Function = function(...args):void
									{ 
										assertEquals(args.length, 2);
										assertEquals(args[0], 12345678);
										assertEquals(args[1], 'text');
									};
			
			signal.add(listener).params = [12345678].concat(['text']);
						
			signal.dispatch();
		}
		
		
		[Test]
		public function verify_chaining_and_pushing_on_to_slot_params():void
		{
			var listener:Function = function(...args):void
									{ 
										assertEquals(args.length, 2);
										assertEquals(args[0], 123456789);
										assertEquals(args[1], 'text');
									};
			
			// This is ugly, but I put money on somebody will attempt to do this!
			
			var slots:ISlot;
			(slots = signal.add(listener)).params = [123456789];
			slots.params.push('text');
			
			signal.dispatch();
		}
	}
}

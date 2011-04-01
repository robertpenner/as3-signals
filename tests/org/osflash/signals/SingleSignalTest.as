package org.osflash.signals
{
	import flash.errors.IllegalOperationError;
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertNull;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	import flash.display.Sprite;
	
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class SingleSignalTest
	{
		[Inject]
	    public var async:IAsync;
		
		public var completed:SingleSignal;
		
		[Before]
		public function setUp():void
		{
			completed = new SingleSignal();
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		
		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(0, completed.numListeners);
		}
		
		//////
		
		[Test]
		public function dispatch_should_pass_event_to_listener_but_not_set_signal_or_target_properties():void
		{
			completed.add(async.add(checkGenericEvent, 10));
			completed.dispatch(new GenericEvent());
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		
		//////
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function add_two_listeners_should_throw_an_error():void
		{
			completed.add(checkGenericEvent);
			completed.add(checkGenericEvent);
		}
		
		//////
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function add_one_hundred_listeners_should_throw_an_error():void
		{
			for(var i : int = 0; i<100; i++)
			{
				completed.add(checkGenericEvent);
			}
		}
		
		//////
		
		[Test]
		public function add_one_listeners_then_remove_it_then_add_another_listener():void
		{
			completed.add(failIfCalled);
			completed.remove(failIfCalled);
			completed.add(checkGenericEvent);
			completed.dispatch(new GenericEvent());
		}	
		
		//////
		
		[Test]
		public function addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			completed.addOnce(newEmptyHandler());
			completed.dispatch(new GenericEvent());
			assertEquals('there should be no listeners', 0, completed.numListeners);
		}
		
		//////
		
		[Test]
		public function add_listener_then_remove_then_dispatch_should_not_call_listener():void
		{
			completed.add(failIfCalled);
			completed.remove(failIfCalled);
			completed.dispatch(new GenericEvent());
		}
		
		private function failIfCalled(e:IEvent):void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			completed.add(newEmptyHandler());
			completed.remove(newEmptyHandler());
			assertEquals(1, completed.numListeners);
		}
		
		private function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		
		//////
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function addOnce_same_listener_twice_should_only_add_it_once():void
		{
			var func:Function = newEmptyHandler();
			completed.addOnce(func);
			completed.addOnce(func);
		}
		
		//////
		[Test]
		public function dispatch_non_IEvent_without_error():void
		{
			completed.addOnce(checkSprite);
			// Sprite doesn't have a target property,
			// so if the signal tried to set .target,
			// an error would be thrown and this test would fail.
			completed.dispatch(new Sprite());
		}
		
		private function checkSprite(sprite:Sprite):void
		{
			assertTrue(sprite is Sprite);
		}
		
		//////
		[Test]
		public function adding_a_listener_during_dispatch_should_not_call_it():void
		{
			completed.add(async.add(addListenerDuringDispatch, 10));
			completed.dispatch(new GenericEvent());
		}
		
		private function addListenerDuringDispatch():void
		{
			try
			{
				completed.add(failIfCalled);
			}
			catch(error : IllegalOperationError)
			{
				assertTrue('there should be 1 listener', completed.numListeners == 1);
			}
			catch(error : Error)
			{
				fail('This error should not have been thrown.');
			}
		}
		
		//////
		[Test]
		public function removed_listener_should_be_returned():void
		{
			var binding:ISignalBinding = completed.add(function():void{});
			var listener:Function = binding.listener;
			
			assertTrue("Listener is returned", listener == completed.remove(listener));
		}
	}
}

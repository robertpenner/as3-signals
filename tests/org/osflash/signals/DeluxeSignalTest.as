package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit4.async.addAsync;

	public class DeluxeSignalTest
	{
		private var completed:DeluxeSignal;
		
		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
		}
		
		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}

		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			completed.add(newEmptyHandler());
			completed.remove(newEmptyHandler());
			assertEquals(1, completed.numListeners);
		}
		
		private function newEmptyHandler():Function
		{
			return function():void {};
		}
		
		//////
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_itself_then_2nd_listener_is_still_called():void
		{
			completed.add(selfRemover);
			// addAsync verifies the second listener is called
			completed.add(addAsync(newEmptyHandler(), 10));
			completed.dispatch();
		}
		
		private function selfRemover():void
		{
			completed.remove(selfRemover);
		}
		//////
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_all_then_2nd_listener_is_still_called():void
		{
			completed.add(addAsync(allRemover, 10));
			completed.add(addAsync(newEmptyHandler(), 10));
			completed.dispatch();
		}
		
		private function allRemover():void
		{
			completed.removeAll();
		}
		//////
		[Test]
		public function adding_a_listener_during_dispatch_should_not_call_it():void
		{
			completed.add(addAsync(addListenerDuringDispatch, 10));
			completed.dispatch();
		}
		
		private function addListenerDuringDispatch():void
		{
			completed.add(failIfCalled);
		}
		
		private function failIfCalled():void
		{
			fail("This listener should not be called.");
		}
		
		
		//////
		[Test]
		public function can_use_anonymous_listeners():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(completed.add(function():void{}));
			}
			
			assertTrue("there should be 100 listeners", completed.numListeners == 100);
			
			for each( var fnt:Function in listeners )
			{
				completed.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", completed.numListeners == 0);
		}
		
		//////
		[Test]
		public function can_use_anonymous_listeners_in_addOnce():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(completed.addOnce(function():void{}));
			}
			
			assertTrue("there should be 100 listeners", completed.numListeners == 100);
			
			for each( var fnt:Function in listeners )
			{
				completed.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", completed.numListeners == 0);
		}
	}
}

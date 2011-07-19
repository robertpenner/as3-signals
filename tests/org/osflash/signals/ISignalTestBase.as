package org.osflash.signals 
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ISignalTestBase
	{
	    [Inject]
	    public var async:IAsync;
	    
		protected var signal:ISignal;
		
		[After]
		public function destroySignal():void
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
		public function addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			signal.addOnce(newEmptyHandler());
			dispatchSignal();
			assertEquals('there should be no listeners', 0, signal.numListeners);
		}	
		
		[Test]
		public function add_listener_then_remove_then_dispatch_should_not_call_listener():void
		{
			signal.add(failIfCalled);
			signal.remove(failIfCalled);
			dispatchSignal();
		}
		
		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			signal.add(newEmptyHandler());
			signal.remove(newEmptyHandler());
			assertEquals(1, signal.numListeners);
		}
		
		[Test]
		public function add_2_listeners_remove_2nd_then_dispatch_should_call_1st_not_2nd_listener():void
		{
			var called:Boolean = false;
			signal.add(function(e:* = null):void { called = true; });
			signal.add(failIfCalled);
			signal.remove(failIfCalled);
			dispatchSignal();
			assertTrue(called);
		}
		
		[Test]
		public function add_2_listeners_should_yield_numListeners_of_2():void
		{
			signal.add(newEmptyHandler());
			signal.add(newEmptyHandler());
			assertEquals(2, signal.numListeners);
		}
		
		[Test]
		public function add_2_listeners_then_remove_1_should_yield_numListeners_of_1():void
		{
			var firstFunc:Function = newEmptyHandler();
			signal.add(firstFunc);
			signal.add(newEmptyHandler());
			signal.remove(firstFunc);
			
			assertEquals(1, signal.numListeners);
		}
		
		[Test]
		public function add_2_listeners_then_removeAll_should_yield_numListeners_of_0():void
		{
			signal.add(newEmptyHandler());
			signal.add(newEmptyHandler());
			signal.removeAll();
			assertEquals(0, signal.numListeners);
		}
		
		[Test]
		public function add_same_listener_twice_should_only_add_it_once():void
		{
			var func:Function = newEmptyHandler();
			signal.add(func);
			signal.add(func);
			assertEquals(1, signal.numListeners);
		}
		
		[Test]
		public function addConditionally_same_listener_twice_should_only_add_it_once():void
		{
			const func:Function = newEmptyHandler();
			signal.addConditionally(func);
			signal.addConditionally(func);
			assertEquals(1, signal.numListeners);
		}
		
		[Test]
		public function addOnce_same_listener_twice_should_only_add_it_once():void
		{
			var func:Function = newEmptyHandler();
			signal.addOnce(func);
			signal.addOnce(func);
			assertEquals(1, signal.numListeners);
		}
		
		[Test]
		public function add_two_listeners_and_dispatch_should_call_both():void
		{
			var calledA:Boolean = false;
			var calledB:Boolean = false;
			signal.add(function(e:* = null):void { calledA = true; });
			signal.add(function(e:* = null):void { calledB = true; });
			dispatchSignal();
			assertTrue(calledA);
			assertTrue(calledB);
		}
		
		[Test]
		public function add_the_same_listener_twice_should_not_throw_error():void
		{
			var listener:Function = newEmptyHandler();
			signal.add(listener);
			signal.add(listener);
		}
		
		[Test]
		public function strict_should_be_true() : void
		{
			assertTrue('strict should be true', signal.strict);
		}
		
		
		[Test]
		public function verify_strict_after_setting_it_to_false() : void
		{
			signal.strict = false;
			assertFalse('strict should be false', signal.strict);
		}
		
		[Test]
		public function verify_strict_is_true_after_dispatch() : void
		{
			signal.add(newEmptyHandler());
			dispatchSignal();
			assertTrue('strict should be true', signal.strict);
		}
		
		[Test]
		public function set_strict_to_false_and_verify_strict_is_false_after_dispatch() : void
		{
			signal.strict = false;
			
			signal.add(newEmptyHandler());
			dispatchSignal();
			
			assertFalse('strict should be false', signal.strict);
		}
		
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_itself_then_2nd_listener_is_still_called():void
		{
			signal.add(selfRemover);
			// async.add verifies the second listener is called
			signal.add(async.add(newEmptyHandler(), 10));
			dispatchSignal();
		}
		
		private function selfRemover(e:* = null):void
		{
			signal.remove(selfRemover);
		}
		
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_all_then_2nd_listener_is_still_called():void
		{
			signal.add(async.add(allRemover, 10));
			signal.add(async.add(newEmptyHandler(), 10));
			dispatchSignal();
		}

		private function allRemover(e:* = null):void
		{
			signal.removeAll();
		}
		
		[Test]
		public function adding_a_listener_during_dispatch_should_not_call_it():void
		{
			signal.add(async.add(addListenerDuringDispatch, 10));
			dispatchSignal();
		}
		
		private function addListenerDuringDispatch(e:* = null):void
		{
			signal.add(failIfCalled);
		}	
		
		//TODO: clarify test purpose through naming and/or implementation
		[Test]
		public function can_use_anonymous_listeners():void
		{
			var bindings:Array = [];
			
			for ( var i:int = 0; i < 10;  i++ )
			{
				bindings.push(signal.add(newEmptyHandler()));
			}
			assertEquals("there should be 10 listeners", 10, signal.numListeners);

			for each( var binding:ISignalBinding in bindings )
			{
				signal.remove(binding.listener);
			}
			assertEquals("all anonymous listeners removed", 0, signal.numListeners);
		}
		
		//TODO: clarify test purpose through naming and/or implementation
		[Test]
		public function can_use_anonymous_listeners_in_addOnce():void
		{
			var bindings:Array = [];
			
			for ( var i:int = 0; i < 10;  i++ )
			{
				bindings.push(signal.addOnce(newEmptyHandler()));
			}
			assertEquals("there should be 10 listeners", 10, signal.numListeners);

			for each( var binding:ISignalBinding in bindings )
			{
				signal.remove(binding.listener);
			}
			assertEquals("all anonymous listeners removed", 0, signal.numListeners);
		}		
		
		[Test]
		public function addConditionally_removes_listener_when_listener_returns_true():void
		{
			signal.addConditionally(function(e:* = null, ...args):Boolean{return true;});
			assertEquals("there should be 1 listener", 1, signal.numListeners);
			dispatchSignal();
			assertEquals("addConditionally removed listener func when it returned true", 0, signal.numListeners);
		}
		
		[Test]
		public function addConditionally_does_not_remove_listener_when_listener_returns_false():void
		{
			signal.addConditionally(function(e:* = null, ...args):Boolean{return false;});
			assertEquals("there should be 1 listener", 1, signal.numListeners);
			dispatchSignal();
			assertEquals("addConditionally didn't remove the listener func when it returned false", 1, signal.numListeners);
		}
		
		[Test]
		public function addConditionally_does_not_remove_listener_when_listener_return_type_is_void():void
		{
			signal.addConditionally(newEmptyHandler());
			assertEquals("there should be 1 listener", 1, signal.numListeners);
			dispatchSignal();
			assertEquals("addConditionally didn't remove the listener func when its return type is void", 1, signal.numListeners);
		}
	
		[Test]
		public function add_listener_returns_binding_with_same_listener():void
		{
			var listener:Function = newEmptyHandler();
			var binding:ISignalBinding = signal.add(listener);
			assertSame(listener, binding.listener);
		}
		
		[Test]
		public function remove_listener_returns_same_binding_as_when_it_was_added():void
		{
			var listener:Function = newEmptyHandler();
			var binding:ISignalBinding = signal.add(listener);
			assertSame(binding, signal.remove(listener));
		}
		
		protected function dispatchSignal():void 
		{
			signal.dispatch(new Event('test'));
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
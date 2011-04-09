package org.osflash.signals
{
	import asunit.asserts.assertNull;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalBindingTest
	{
		
		[Inject]
	    public var async:IAsync;
	    
		public var completed:Signal;
		
		[Before]
		public function setUp():void
		{
			completed = new Signal();
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
		public function add_listener_and_verify_once_is_false() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.add(listener);
			
			assertTrue('Binding once is false', binding.once == false);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.add(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.add(listener);
			var binding1 : ISignalBinding = completed.add(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.add(listener);
			var binding1 : ISignalBinding = completed.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function add_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.add(listener);
			completed.add(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = completed.add(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = completed.add(failIfCalled);
			binding.enabled = false;
			
			completed.dispatch();
		}
		
		//////
		
		[Test]
		public function add_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = completed.add(async.add(checkGenericEvent, 10));
			binding.enabled = false;
			binding.enabled = true;
			
			completed.dispatch(new GenericEvent());
		}
		
		//////
		
		[Test]
		public function add_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = completed.add(failIfCalled);
			binding.enabled = false;
			binding.enabled = true;
			binding.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			binding.listener = newEmptyHandler();
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			binding.listener = failIfCalled;
			binding.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function add_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			
			completed.dispatch();
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			completed.dispatch();
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function add_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.listener = null;
		}
		
		//////
		
		[Test]
		public function add_listener_and_call_execute0_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute0(); 
		}
		
		//////
		
		[Test]
		public function add_listener_twice_and_call_execute0_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.add(failIfCalled);
			
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute0(); 
		}
		
		//////
		
		[Test]
		public function add_listener_and_call_execute1_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute1(1); 
		}
		
		//////
		
		[Test]
		public function add_listener_twice_and_call_execute1_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.add(failIfCalled);
			
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute1(1); 
		}
		
		//////
		
		[Test]
		public function add_listener_and_call_execute2_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute2(1, 2); 
		}
		
		//////
		
		[Test]
		public function add_listener_twice_and_call_execute2_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.add(failIfCalled);
			
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute2(1, 2); 
		}
		
		//////
		
		[Test]
		public function add_listener_and_call_execute_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function add_listener_twice_and_call_execute_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.add(failIfCalled);
			
			var binding : ISignalBinding = completed.add(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_once_is_true() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.addOnce(listener);
			
			assertTrue('Binding once is true', binding.once == true);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.addOnce(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.addOnce(listener);
			var binding1 : ISignalBinding = completed.addOnce(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.addOnce(listener);
			var binding1 : ISignalBinding = completed.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = completed.addOnce(listener);
			completed.addOnce(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = completed.addOnce(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', completed.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = completed.addOnce(failIfCalled);
			binding.enabled = false;
			
			completed.dispatch();
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = completed.addOnce(async.add(checkGenericEvent, 10));
			binding.enabled = false;
			binding.enabled = true;
			
			completed.dispatch(new GenericEvent());
		}
		
		//////
		
		[Test]
		public function addOnce_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = completed.addOnce(failIfCalled);
			binding.enabled = false;
			binding.enabled = true;
			binding.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			binding.listener = newEmptyHandler();
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			binding.listener = failIfCalled;
			binding.enabled = false;
			
			completed.dispatch();			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			
			completed.dispatch();
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			completed.dispatch();
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.listener = null;
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute0_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute0(); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_twice_and_call_execute0_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.addOnce(failIfCalled);
			
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute0(); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute1_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute1(1); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_twice_and_call_execute1_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.addOnce(failIfCalled);
			
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute1(1); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute2_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute2(1, 2); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_twice_and_call_execute2_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.addOnce(failIfCalled);
			
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute2(1, 2); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_twice_and_call_execute_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			completed.addOnce(failIfCalled);
			
			var binding : ISignalBinding = completed.addOnce(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
	}
}

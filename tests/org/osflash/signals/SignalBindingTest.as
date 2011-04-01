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
		
		//////
		
		[Test]
		public function add_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = completed.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		
		protected function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		
		protected function failIfCalled():void
		{
			fail('This event handler should not have been called.');
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
			binding.pause();
			
			completed.dispatch();
		}
		
		//////
		
		[Test]
		public function add_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = completed.add(async.add(checkGenericEvent, 10));
			binding.pause();
			binding.resume();
			
			completed.dispatch(new GenericEvent());
		}
	}
}

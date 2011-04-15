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
	public class ISignalBindingTestBase
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
		
		protected function newEmptyHandler():Function
		{
			return function(e:*=null, ...args):void {};
		}
		
		protected function failIfCalled(e:*=null, ...args):void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function verify_strict_on_binding_after_dispatch_equals_true() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
				
			signal.dispatch(new Event('click'));
							
			assertTrue('Binding strict is true', binding.strict);
		}
		
		//////
		
		[Test]
		public function set_strict_to_false_and_verify_strict_on_binding_after_dispatch_equals_false() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			binding.strict = false;
				
			signal.dispatch(new Event('click'));
							
			assertFalse('Binding strict is false', binding.strict);
		}
		
		//////
		
		[Test]
		public function add_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = signal.add(failIfCalled);
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
		
		
		//////
		
		[Test]
		public function add_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = signal.add(failIfCalled);
			binding.enabled = false;
			binding.enabled = true;
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			binding.listener = newEmptyHandler();
			
			signal.dispatch(new Event('click'));		
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			binding.listener = failIfCalled;
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		//////
		
		[Test]
		public function add_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			signal.dispatch(new Event('click'));
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = signal.addOnce(failIfCalled);
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
		
		//////
		
		[Test]
		public function addOnce_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = signal.addOnce(failIfCalled);
			binding.enabled = false;
			binding.enabled = true;
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));		
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			binding.listener = newEmptyHandler();
			
			signal.dispatch(new Event('click'));		
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			binding.listener = failIfCalled;
			binding.enabled = false;
			
			signal.dispatch(new Event('click'));
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			
			signal.dispatch(new Event('click'));
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			signal.dispatch(new Event('click'));
		}
		
		//////
		
		[Test]
		public function verify_listeners_that_are_strict_and_not_strict() : void
		{
			signal.add(newEmptyHandler());
			
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.strict = false;
			
			signal.dispatch(new Event('click'));
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_once_is_false() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			
			assertFalse('Binding once is false', binding.once);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_strict_is_true() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			
			assertTrue('Binding strict is true', binding.strict);
		}
		
		//////
		
		[Test]
		public function verify_strict_on_binding_after_setting_to_false() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			binding.strict = false;
			
			assertFalse('Binding strict is false', binding.strict);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.add(listener);
			var binding1 : ISignalBinding = signal.add(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.add(listener);
			var binding1 : ISignalBinding = signal.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function add_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.add(listener);
			signal.add(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = signal.add(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function add_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.listener = null;
		}
				
		//////
		
		[Test]
		public function add_listener_and_call_execute_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function add_listener_twice_and_call_execute_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			signal.add(failIfCalled);
			
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_once_is_true() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.addOnce(listener);
			
			assertTrue('Binding once is true', binding.once == true);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.addOnce(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = signal.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.addOnce(listener);
			var binding1 : ISignalBinding = signal.addOnce(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.addOnce(listener);
			var binding1 : ISignalBinding = signal.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = signal.addOnce(listener);
			signal.addOnce(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = signal.addOnce(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', signal.numListeners == 0);
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			binding.listener = null;
		}
				
		//////
		
		[Test]
		public function addOnce_listener_and_call_execute_on_binding_should_call_listener() : void
		{
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function addOnce_listener_twice_and_call_execute_on_binding_should_call_listener_and_not_on_signal_listeners() : void
		{
			signal.addOnce(failIfCalled);
			
			var binding : ISignalBinding = signal.addOnce(newEmptyHandler());
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		//////
		
		[Test]
		public function verify_listeners_that_are_strict_and_not_strict_when_called_on_binding() : void
		{
			signal.add(newEmptyHandler());
			
			var binding : ISignalBinding = signal.add(newEmptyHandler());
			binding.strict = false;
			binding.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]); 
		}
		
		[Test]
		public function binding_params_are_null_when_created():void
		{
			var listener:Function = newEmptyHandler();
			var binding:ISignalBinding = signal.add(listener);

			assertNull('params should be null', binding.params); 
		}

		[Test]
		public function binding_params_should_not_be_null_after_adding_array():void
		{
			var listener:Function = newEmptyHandler();
			var binding:ISignalBinding = signal.add(listener);
			binding.params = [];

			assertNotNull('params should not be null', binding.params); 
		}

		[Test]
		public function binding_params_with_one_param_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertTrue(args[0] is int);
										assertEquals(args[0], 1234);
									};

			var binding:ISignalBinding = signal.add(listener);
			binding.params = [1234];

			signal.dispatch(new MouseEvent('click'));
		}	

		[Test]
		public function binding_params_with_multiple_params_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
											
										assertTrue(args[0] is int);
										assertEquals(args[0], 12345);
										
										assertTrue(args[1] is String);
										assertEquals(args[1], 'text');
										
										assertTrue(args[2] is Sprite);
										assertEquals(args[2], binding.params[2]);
									};

			var binding:ISignalBinding = signal.add(listener);
			binding.params = [12345, 'text', new Sprite()];

			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function binding_params_should_not_effect_other_bindings():void
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
			
			var binding:ISignalBinding = signal.add(listener1);
			binding.params = [123456];
			
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function verify_chaining_of_binding_params():void
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
		public function verify_chaining_and_concat_of_binding_params():void
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
		public function verify_chaining_and_pushing_on_to_binding_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 2);
										assertEquals(args[0], 123456789);
										assertEquals(args[1], 'text');
									};
			
			// This is ugly, but I put money on somebody will attempt to do this!
			
			var bindings:ISignalBinding;
			(bindings = signal.add(listener)).params = [123456789];
			bindings.params.push('text');
			
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function non_strict_signal_binding_params_with_one_param_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertTrue(args[0] is int);
										assertEquals(args[0], 1234);
									};
			
			signal.strict = false;
			
			var binding:ISignalBinding = signal.add(listener);
			binding.params = [1234];

			signal.dispatch(new MouseEvent('click'));
		}	

		[Test]
		public function non_strict_signal_binding_params_with_multiple_params_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
											
										assertTrue(args[0] is int);
										assertEquals(args[0], 12345);
										
										assertTrue(args[1] is String);
										assertEquals(args[1], 'text');
										
										assertTrue(args[2] is Sprite);
										assertEquals(args[2], binding.params[2]);
									};
									
			signal.strict = false;

			var binding:ISignalBinding = signal.add(listener);
			binding.params = [12345, 'text', new Sprite()];

			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function non_strict_signal_binding_params_should_not_effect_other_bindings():void
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
									
			signal.strict = false;
			
			var binding:ISignalBinding = signal.add(listener1);
			binding.params = [123456];
			
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function non_strict_signal_verify_chaining_of_binding_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 1);
										assertEquals(args[0], 1234567);
									};
									
			signal.strict = false;
			
			signal.add(listener).params = [1234567];
						
			signal.dispatch(new MouseEvent('click'));
		}
		
		[Test]
		public function non_strict_signal_verify_chaining_and_concat_of_binding_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 2);
										assertEquals(args[0], 12345678);
										assertEquals(args[1], 'text');
									};
			
			signal.strict = false;
			
			signal.add(listener).params = [12345678].concat(['text']);
						
			signal.dispatch(new MouseEvent('click'));
		}
		
		
		[Test]
		public function non_strict_signal_verify_chaining_and_pushing_on_to_binding_params():void
		{
			var listener:Function = function(e:Event, ...args):void
									{ 
										assertNotNull(e);
										
										assertEquals(args.length, 2);
										assertEquals(args[0], 123456789);
										assertEquals(args[1], 'text');
									};
			
			signal.strict = false;
			
			// This is ugly, but I put money on somebody will attempt to do this!
			
			var bindings:ISignalBinding;
			(bindings = signal.add(listener)).params = [123456789];
			bindings.params.push('text');
			
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

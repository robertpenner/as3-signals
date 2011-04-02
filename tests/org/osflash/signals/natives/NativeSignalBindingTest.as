package org.osflash.signals.natives
{
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.events.GenericEvent;

	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class NativeSignalBindingTest
	{
		[Inject]
	    public var async:IAsync;
	    
		public var clicked:NativeSignal;
		private var sprite:IEventDispatcher;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeSignal(sprite, 'click', MouseEvent);
		}

		[After]
		public function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}
		
		protected function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		
		protected function newEmptyHandler():Function
		{
			return function(e:MouseEvent):void {};
		}
		
		protected function failIfCalled(e:MouseEvent):void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_once_is_false() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.add(listener);
			
			assertTrue('Binding once is false', binding.once == false);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.add(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.add(listener);
			var binding1 : ISignalBinding = clicked.add(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.add(listener);
			var binding1 : ISignalBinding = clicked.add(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function add_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = clicked.add(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.add(listener);
			clicked.add(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = clicked.add(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function add_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = clicked.add(failIfCalled);
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test]
		public function add_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = clicked.add(async.add(onClicked, 10));
			binding.pause();
			binding.resume();
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test]
		public function add_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = clicked.add(failIfCalled);
			binding.pause();
			binding.resume();
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = clicked.add(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			binding.listener = newEmptyHandler();
			
			sprite.dispatchEvent(new MouseEvent('click'));			
		}
		
		//////
		
		[Test]
		public function add_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = clicked.add(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			binding.listener = failIfCalled;
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));			
		}
		
		//////
		
		[Test]
		public function add_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = clicked.add(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function add_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = clicked.add(newEmptyHandler());
			binding.listener = null;
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_once_is_true() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.addOnce(listener);
			
			assertTrue('Binding once is true', binding.once == true);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_priority_is_zero() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.addOnce(listener);
			
			assertTrue('Binding priority is zero', binding.priority == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_verify_binding_listener_is_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding : ISignalBinding = clicked.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding.listener === listener);
		}
				
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_bindings_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.addOnce(listener);
			var binding1 : ISignalBinding = clicked.addOnce(listener);
			
			assertTrue('Bindings are equal if they\'re they have the same listener', binding0 === binding1);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_verify_binding_listeners_are_the_same() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.addOnce(listener);
			var binding1 : ISignalBinding = clicked.addOnce(listener);
			
			assertTrue('Binding listener is the same as the listener', binding0.listener === binding1.listener);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_and_remove_using_binding() : void
		{
			var binding : ISignalBinding = clicked.addOnce(newEmptyHandler());
			binding.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_same_listener_twice_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			var binding0 : ISignalBinding = clicked.addOnce(listener);
			clicked.addOnce(listener);
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_lots_of_same_listener_and_remove_using_binding_should_have_no_listeners() : void
		{
			var listener : Function = newEmptyHandler();
			for(var i : int = 0; i<100; i++)
			{
				var binding0 : ISignalBinding = clicked.addOnce(listener);
			}
			
			binding0.remove();
			
			assertTrue('Number of listeners should be 0', clicked.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = clicked.addOnce(failIfCalled);
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test]
		public function addOnce_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = clicked.addOnce(async.add(onClicked, 10));
			binding.pause();
			binding.resume();
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test]
		public function addOnce_listener_switch_pause_and_resume_on_binding_should_not_dispatch() : void
		{
			var binding : ISignalBinding = clicked.addOnce(failIfCalled);
			binding.pause();
			binding.resume();
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_should_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = clicked.addOnce(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			binding.listener = newEmptyHandler();
			
			sprite.dispatchEvent(new MouseEvent('click'));			
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_dispatch_change_listener_on_binding_then_pause_should_not_dispatch_second_listener() : void
		{
			var binding : ISignalBinding = clicked.addOnce(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			binding.listener = failIfCalled;
			binding.pause();
			
			sprite.dispatchEvent(new MouseEvent('click'));		
		}
		
		//////
		
		[Test]
		public function addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : void
		{
			var binding : ISignalBinding = clicked.addOnce(newEmptyHandler());
			
			sprite.dispatchEvent(new MouseEvent('click'));
			
			var listener : Function = binding.listener;
			
			binding.listener = failIfCalled;
			binding.listener = listener;
			
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		//////
		
		[Test(expects="ArgumentError")]
		public function addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError() : void
		{
			var binding : ISignalBinding = clicked.addOnce(newEmptyHandler());
			binding.listener = null;
		}
	}
}

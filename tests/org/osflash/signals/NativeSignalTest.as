package org.osflash.signals
{
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class NativeSignalTest extends TestCase
	{
		private var clicked:NativeSignal;
		private var sprite:IEventDispatcher;

		public function NativeSignalTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeSignal(sprite, 'click', MouseEvent);
		}

		protected override function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}

		public function testInstantiated():void
		{
			assertTrue("NativeSignal instantiated", clicked is NativeSignal);
			assertTrue('implements INativeSignal', clicked is INativeSignal);
			assertTrue('implements IListeners', clicked is IListeners);
			assertTrue('implements INativeDispatcher', clicked is INativeDispatcher);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
			assertSame('target round-trips through constructor', sprite, clicked.target);
		}
		//////
		public function test_signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( addAsync(onClicked, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		public function test_when_signal_adds_listener_then_target_should_have_listener():void
		{
			clicked.add(emptyHandler);
			assertEquals(1, clicked.numListeners);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void {}
		
		public function test_when_signal_adds_then_removes_listener_then_target_should_not_have_listener():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			assertEquals(0, clicked.numListeners);
			assertFalse(sprite.hasEventListener('click'));
		}
		
		public function test_when_signal_removes_all_listeners_then_target_should_not_have_listener():void
		{
			clicked.add(emptyHandler);
			clicked.add( function(e:*):void {} );
			clicked.removeAll();
			assertEquals(0, clicked.numListeners);
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
		public function test_addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			clicked.addOnce(emptyHandler);
			clicked.dispatch(new MouseEvent('click'));
			assertEquals('there should be no listeners', 0, clicked.numListeners);
		}
		//////
		public function test_adding_listener_without_args_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, addListenerWithoutArgs);
		}
		
		private function addListenerWithoutArgs():void
		{
			clicked.add(noArgs);
		}
		
		private function noArgs():void
		{
		}
		//////
		public function test_adding_listener_with_two_args_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, addListenerWithTwoArgs);
		}
		
		private function addListenerWithTwoArgs():void
		{
			clicked.add(twoArgs);
		}
		
		private function twoArgs(a:*, b:*):void
		{
		}
		//////
		public function test_dispatch_wrong_event_class_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, dispatchWrongEventClass);
		}
		
		private function dispatchWrongEventClass():void
		{
			clicked.dispatch(new Event('click'));
		}
		//////
		public function test_dispatch_event_with_type_not_matching_signal_name_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, dispatchWrongEventType);
		}
		
		private function dispatchWrongEventType():void
		{
			clicked.dispatch(new MouseEvent('rollOver'));
		}
		//////
		public function test_dispatch_null_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, dispatchNonEventObject);
		}
		
		private function dispatchNonEventObject():void
		{
			clicked.dispatch(null);
		}
		//////
		public function test_eventClass_defaults_to_native_Event_class():void
		{
			var added:NativeSignal = new NativeSignal(sprite, 'added');
			assertSame(Event, added.eventClass);
		}
	}
}

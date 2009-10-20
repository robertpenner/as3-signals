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
			// tearDown() is getting called too early for some reason, so commenting out for now.
			//clicked.removeAll();
			//clicked = null;
		}
		
		override protected function addAsync(handler:Function = null, duration:Number = 1, failureHandler:Function = null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		
		protected function verifyNoListeners():void
		{
			assertFalse('the EventDispatcher should not have listeners for the event', sprite.hasEventListener('click'));
			assertEquals('the NativeSignal should have no listeners', 0, clicked.numListeners);
		}
		//////
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
			clicked.add( addAsync(onClicked) );
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
		
		public function test_when_signal_adds_then_removes_listener_then_target_should_not_have_listeners():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			verifyNoListeners();
		}
		
		public function test_when_signal_removes_all_listeners_then_target_should_not_have_listeners():void
		{
			clicked.add(emptyHandler);
			clicked.add( function(e:*):void {} );
			clicked.removeAll();
			verifyNoListeners();
		}
		
		public function test_when_addOnce_and_removeAll_listeners_then_target_should_not_have_listeners():void
		{
			clicked.addOnce(emptyHandler);
			clicked.addOnce( function(e:*):void {} );
			clicked.removeAll();
			verifyNoListeners();
		}
		//////
		public function test_addOnce_and_dispatch_from_signal_should_remove_listener_automatically():void
		{
			clicked.addOnce( addAsync(emptyHandler) );
			clicked.dispatch(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		public function test_addOnce_normal_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var normalPriority:int = 0;
			clicked.addOnce( addAsync(emptyHandler) , normalPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		public function test_addOnce_lowest_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var lowestPriority:int = int.MIN_VALUE;
			clicked.addOnce( addAsync(emptyHandler) , lowestPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		public function test_addOnce_highest_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var highestPriority:int = int.MAX_VALUE;
			clicked.addOnce( addAsync(emptyHandler) , highestPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
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
			var wrongType:String = 'rollOver';
			clicked.dispatch(new MouseEvent(wrongType));
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

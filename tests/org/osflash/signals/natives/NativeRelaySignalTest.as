package org.osflash.signals.natives
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	import org.osflash.signals.ISignal;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class NativeRelaySignalTest
	{
		private var clicked:NativeRelaySignal;
		private var sprite:Sprite;

		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeRelaySignal(sprite, 'click', MouseEvent);
		}

		[After]
		public function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}

		public function testInstantiated():void
		{
			assertTrue("NativeRelaySignal instantiated", clicked is NativeRelaySignal);
			assertTrue('implements ISignal', clicked is ISignal);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
		}
		//////
		[Test(async)]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( addAsync(checkSpriteAsCurrentTarget, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function checkSpriteAsCurrentTarget(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		[Test(async)]
		public function signal_addOnce_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.addOnce( addAsync(checkSpriteAsCurrentTarget, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		//////
		[Test]
		public function when_signal_adds_listener_then_hasEventListener_should_be_true():void
		{
			clicked.add(emptyHandler);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void { }
		
		[Test]
		public function when_signal_addOnce_listener_then_hasEventListener_should_be_true():void
		{
			clicked.addOnce(emptyHandler);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		[Test]
		public function when_signal_adds_then_removes_listener_then_hasEventListener_should_be_false():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			assertFalse(sprite.hasEventListener('click'));
		}
		
		[Test]
		public function when_signal_addOnce_then_removes_listener_then_hasEventListener_should_be_false():void
		{
			clicked.addOnce(emptyHandler);
			clicked.remove(emptyHandler);
			assertFalse(sprite.hasEventListener('click'));
		}
		
		[Test]
		public function when_signal_adds_then_removeAll_listeners_then_hasEventListener_should_be_false():void
		{
			clicked.add(emptyHandler);
			clicked.removeAll();
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
		[Test]
		public function setting_target_to_a_different_object_should_remove_all_listeners_from_1st_target():void
		{
			clicked.add(emptyHandler);
			clicked.target = new EventDispatcher();
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
		[Test]
		public function setting_target_to_the_same_object_should_not_remove_listeners():void
		{
			clicked.add(emptyHandler);
			var numListenersBefore:uint = clicked.numListeners;
			clicked.target = sprite;
			assertEquals(numListenersBefore, clicked.numListeners);
		}
		//////
		[Test]
		public function addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			clicked.addOnce(emptyHandler);
			clicked.dispatch(new MouseEvent('click'));
			assertEquals('there should be no listeners', 0, clicked.numListeners);
		}
	}
}

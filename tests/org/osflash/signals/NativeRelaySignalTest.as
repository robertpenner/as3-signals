package org.osflash.signals
{
	import asunit.asserts.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NativeRelaySignalTest
	{
		private var clicked:ISignal;
		private var sprite:Sprite;

		public function NativeRelaySignalTest(testMethod:String = null)
		{
			super(testMethod);
		}

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
		[Test]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( addAsync(onClicked, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		[Test]
		public function when_signal_adds_listener_then_hasEventListener_should_be_true():void
		{
			clicked.add(emptyHandler);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void {}
		
		[Test]
		public function when_signal_adds_then_removes_listener_then_hasEventListener_should_be_false():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
	}
}

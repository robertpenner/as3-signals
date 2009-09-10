package com.robertpenner.signals
{
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class EventDispatcherSignalTest extends TestCase
	{
		private var click:ISignal;
		private var sprite:Sprite;

		public function EventDispatcherSignalTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			sprite = new Sprite();
			click = new EventDispatcherSignal(sprite, 'click', MouseEvent);
		}

		protected override function tearDown():void
		{
			click.removeAll();
			click = null;
		}

		public function testInstantiated():void
		{
			assertTrue("EventDispatcherSignal instantiated", click is EventDispatcherSignal);
			assertTrue('implements ISignal', click is ISignal);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
		}
		//////
		public function test_signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			click.add( addAsync(onClicked, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		public function test_when_signal_adds_listener_then_hasEventListener_should_be_true():void
		{
			click.add(emptyHandler);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void {}
		
		public function test_when_signal_adds_then_removes_listener_then_hasEventListener_should_be_false():void
		{
			click.add(emptyHandler);
			click.remove(emptyHandler);
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
	}
}

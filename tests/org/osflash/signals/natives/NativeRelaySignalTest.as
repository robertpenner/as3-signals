package org.osflash.signals.natives
{
	import asunit.asserts.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class NativeRelaySignalTest extends INativeDispatcherTestBase
	{	
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeRelaySignal(sprite, 'click', MouseEvent);
			signal = new NativeRelaySignal(new EventDispatcher(), 'test', Event);
		}

		[After]
		public function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}

		[Test]
		public function setting_eventClass_to_null_defaults_it_to_Event():void
		{
			NativeRelaySignal(clicked).eventClass = null;
			clicked.dispatch(new Event('click'));
			assertSame(Event, clicked.eventClass);
		}		
	}
}

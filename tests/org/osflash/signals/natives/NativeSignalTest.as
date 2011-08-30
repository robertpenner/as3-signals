package org.osflash.signals.natives
{
	import asunit.asserts.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class NativeSignalTest extends INativeDispatcherTestBase
	{
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeSignal(sprite, 'click', MouseEvent);
			signal = new NativeSignal(new EventDispatcher(), 'test', Event);
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
			NativeSignal(clicked).eventClass = null;
			// This was causing a null exception: Issue #32.
			clicked.dispatch(new Event('click'));
			assertSame(Event, clicked.eventClass);
		}
		
		[Test]
		public function adding_listener_with_no_args_does_not_throw_error():void
		{
			clicked.add(function():void {});
		}

		[Test]
		public function adding_listener_with_varargs_does_not_throw_error():void
		{
			clicked.add(function(...args):void {});
		}

		[Test]
		public function adding_listener_with_more_than_one_arg_does_not_throw_error():void
		{
			clicked.add(function(a:*, b:*):void { } );
		}
		
	}
}

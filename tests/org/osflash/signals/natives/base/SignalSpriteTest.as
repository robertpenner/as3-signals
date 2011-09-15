package org.osflash.signals.natives.base 
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.framework.IAsync;

	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;

	import flash.events.MouseEvent;

	public class SignalSpriteTest 
	{	
		[Inject]
		public var async:IAsync;

		private var sprite:SignalSprite;

		[Before]
		public function setUp():void 
		{
			sprite = new SignalSprite();
		}

		[After]
		public function tearDown():void 
		{
			sprite.signals.removeAll();
			sprite = null;
		}

		[Test]
		public function has_signals_after_creation():void 
		{
			assertTrue(sprite.signals is InteractiveObjectSignalSet);
		}

		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(sprite.signals.numListeners, 0);
		}

		[Test]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			sprite.signals.click.add( async.add(checkClickEvent) );
			sprite.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		private function checkClickEvent(event:MouseEvent):void
		{
			assertSame(MouseEvent.CLICK, event.type);
			assertSame(sprite, event.target);
		}

	}
}

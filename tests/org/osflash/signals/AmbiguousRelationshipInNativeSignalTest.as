package org.osflash.signals
{
	import asunit.asserts.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.errors.IllegalOperationError;
	
	public class AmbiguousRelationshipInNativeSignalTest
	{
		private var target:Sprite;
		
		private var instance:INativeSignal;

		[Before]
		public function setUp():void
		{
			target = new Sprite();
			instance = new NativeSignal(target, Event.CHANGE);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}
		
		[Test]
		public function add_then_addOnce_throws_error():void
		{
			instance.add(failIfCalled);
			assertThrows(IllegalOperationError, function():void { instance.addOnce(failIfCalled); });
		}
		
		[Test]
		public function addOnce_then_add_should_throw_error():void
		{
			instance.addOnce(failIfCalled);
			assertThrows(IllegalOperationError, function():void { instance.add(failIfCalled); });
		}
		
		[Test]
		public function add_then_add_should_not_throw_error():void
		{
			instance.add(failIfCalled);
			instance.add(failIfCalled);
			assertEquals(1, instance.numListeners);
		}
		
		[Test]
		public function addOnce_then_addOnce_should_not_throw_error():void
		{
			instance.addOnce(failIfCalled);
			instance.addOnce(failIfCalled);
			assertEquals(1, instance.numListeners);
		}
		
		private function failIfCalled(event:Event):void
		{
			fail("if this listener is called, something horrible is going on");
		}
		
	}
}

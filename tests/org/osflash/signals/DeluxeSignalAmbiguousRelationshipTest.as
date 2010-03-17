package org.osflash.signals
{
	import asunit.asserts.*;

	public class DeluxeSignalAmbiguousRelationshipTest
	{
		private var target:Object;
		
		private var instance:DeluxeSignal;

		[Before]
		public function setUp():void
		{
			target = {};
			instance = new DeluxeSignal(target);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function add_then_addOnce_throws_error():void
		{
			instance.add(failIfCalled);
			instance.addOnce(failIfCalled);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function addOnce_then_add_should_throw_error():void
		{
			instance.addOnce(failIfCalled);
			instance.add(failIfCalled);
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
		
		private function failIfCalled():void
		{
			fail("if this listener is called, something horrible is going on");
		}
		
	}
}

package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	public class DeluxeSignalDispatchExtraArgsTest
	{
		public var completed:DeluxeSignal;

		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		[Test]
		public function dispatch_extra_args_should_call_listener_with_extra_args():void
		{
			completed.add( addAsync(onCompleted, 10) );
			completed.dispatch(22, 'done', new Date());
		}
		
		private function onCompleted(a:uint, b:String, c:Date):void
		{
			assertEquals(3, arguments.length);
			assertEquals(22, a);
			assertEquals('done', b);
			assertTrue(c is Date);
		}
		//////
		
	}
}

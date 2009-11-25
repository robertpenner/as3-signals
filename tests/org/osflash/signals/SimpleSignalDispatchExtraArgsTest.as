package org.osflash.signals
{
	
	
	
	import asunit.asserts.*;
	import asunit4.async.addAsync;
	
	public class SimpleSignalDispatchExtraArgsTest
	{
		public var completed:Signal;

		[Before]
		public function setUp():void
		{
			completed = new Signal(this);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		[Test(async)]
		public function dispatch_extra_args_should_call_listener_with_extra_args():void
		{
			completed.add( addAsync(onCompleted, 10) );
			completed.dispatch(22, 'done', new Date());
		}
		
		private function onCompleted(...args:Array):void
		{
			assertEquals(3, args.length);
			assertEquals(22, args[0]);
			assertEquals('done', args[1]);
			assertTrue(args[2] is Date);
		}
		//////
		
	}
}

package org.osflash.signals
{
	import asunit.asserts.*;
	import org.osflash.signals.ISignal;

	public class SignalDispatchExtraArgsTest
	{
		public var completed:ISignal;

		public function SignalDispatchExtraArgsTest(testMethod:String = null)
		{
			super(testMethod);
		}

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
		[Test]
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

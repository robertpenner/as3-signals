package org.osflash.signals
{
	import asunit.asserts.*;
	import org.osflash.signals.ISignal;

	public class SignalDispatchNoArgsTest
	{
		public var completed:ISignal;

		public function SignalDispatchNoArgsTest(testMethod:String = null)
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
		public function dispatch_no_args_should_call_listener_with_no_args():void
		{
			completed.add( addAsync(onCompleted, 10) );
			completed.dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		//////
		[Test]
		public function dispatch_null_should_call_listener_with_no_args():void
		{
			completed.addOnce( addAsync(onCompleted, 10) );
			completed.dispatch(null);
		}
		
	}
}

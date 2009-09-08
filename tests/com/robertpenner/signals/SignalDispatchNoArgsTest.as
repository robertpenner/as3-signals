package com.robertpenner.signals
{
	import asunit.framework.TestCase;
	import com.robertpenner.signals.ISignal;

	public class SignalDispatchNoArgsTest extends TestCase
	{
		public var completed:ISignal;

		public function SignalDispatchNoArgsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			completed = new Signal(this);
		}

		protected override function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		public function test_dispatch_no_args_should_call_listener_with_no_args():void
		{
			completed.add( addAsync(onCompleted, 10) );
			completed.dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		//////
		public function test_dispatch_null_should_call_listener_with_no_args():void
		{
			completed.addOnce( addAsync(onCompleted, 10) );
			completed.dispatch(null);
		}
		
	}
}

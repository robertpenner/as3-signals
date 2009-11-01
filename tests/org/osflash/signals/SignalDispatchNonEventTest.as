package org.osflash.signals
{
	import asunit.framework.TestCase;
	import org.osflash.signals.ISignal;

	public class SignalDispatchNonEventTest extends TestCase
	{
		public var completed:ISignal;

		public function SignalDispatchNonEventTest(testMethod:String = null)
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
		
		/**
		 * Captures bug where dispatching 0 was considered null.
		 */
		public function test_dispatch_zero_should_call_listener_with_zero():void
		{
			completed.add( addAsync(onZero, 10) );
			completed.dispatch(0);
		}
		
		private function onZero(num:Number):void
		{
			assertEquals(0, num);
		}
		
	}
}

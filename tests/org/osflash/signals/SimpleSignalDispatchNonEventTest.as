package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit4.async.addAsync;
	import org.osflash.signals.ISignal;

	public class SimpleSignalDispatchNonEventTest
	{
		public var completed:ISimpleSignal;

		[Before]
		public function setUp():void
		{
			completed = new SimpleSignal(this);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		
		/**
		 * Captures bug where dispatching 0 was considered null.
		 */
		[Test(async)]
		public function dispatch_zero_should_call_listener_with_zero():void
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

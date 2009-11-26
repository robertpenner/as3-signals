package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	public class SignalDispatchNonEventTest
	{
		public var completed:Signal;

		[Before]
		public function setUp():void
		{
			completed = new Signal();
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
		//////
		[Test(async)]
		public function dispatch_null_should_call_listener_with_null():void
		{
			completed.addOnce( addAsync(checkNull, 10) );
			completed.dispatch(null);
		}
		
		private function checkNull(signalValue:Object):void
		{
			assertNull(signalValue);
		}
	}
}

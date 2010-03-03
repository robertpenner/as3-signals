package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	public class DeluxeSignalDispatchNonEventTest
	{
		public var completed:DeluxeSignal;

		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this, Date);
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
		[Test]
		public function dispatch_zero_should_call_listener_with_zero():void
		{
			completed = new DeluxeSignal(this, Number);
			completed.add( addAsync(onZero, 10) );
			completed.dispatch(0);
		}
		
		private function onZero(num:Number):void
		{
			assertEquals(0, num);
		}
		//////
		[Test]
		public function dispatch_null_should_call_listener_with_null():void
		{
			completed.addOnce( addAsync(checkNullDate, 10) );
			completed.dispatch(null);
		}
		
		private function checkNullDate(date:Date):void
		{
			assertNull(date);
		}
		//////
		[Test]
		public function dispatch_null_through_int_DeluxeSignal_should_be_autoconverted_to_zero():void
		{
			completed = new DeluxeSignal(int);
			completed.addOnce( addAsync(checkNullConvertedToZero, 10) );
			completed.dispatch(null);
		}
		
		private function checkNullConvertedToZero(intValue:int):void
		{
			assertEquals('null was converted to 0', 0, intValue);
		}
	}
}

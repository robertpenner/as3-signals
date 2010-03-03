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
			completed = new Signal(Date);
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
			completed = new Signal(Number);
			completed.add( addAsync(onZero, 10) );
			completed.dispatch(0);
		}
		
		private function onZero(num:Number):void
		{
			assertEquals(0, num);
		}
		//////
		[Test]
		public function dispatch_2_zeroes_should_call_listener_with_2_zeroes():void
		{
			completed = new Signal(Number, Number);
			completed.add( addAsync(onZeroZero, 10) );
			completed.dispatch(0, 0);
		}
		
		private function onZeroZero(a:Object, b:Object):void
		{
			assertEquals(0, a);
			assertEquals(0, b);
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
		public function dispatch_null_through_int_Signal_should_be_autoconverted_to_zero():void
		{
			completed = new Signal(int);
			completed.addOnce( addAsync(checkNullConvertedToZero, 10) );
			completed.dispatch(null);
		}
		
		private function checkNullConvertedToZero(intValue:int):void
		{
			assertEquals('null was converted to 0', 0, intValue);
		}
	}
}

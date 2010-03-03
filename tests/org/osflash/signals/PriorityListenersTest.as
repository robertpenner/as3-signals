package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	public class PriorityListenersTest
	{
		public var completed:DeluxeSignal;
		private var listenersCalled:Array;

		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
			listenersCalled = [];
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
			listenersCalled = null;
		}
		//////
		[Test]
		public function listener_added_second_with_higher_priority_should_be_called_first():void
		{
			completed.add( addAsync(listener1, 5) );
			completed.add( addAsync(listener0, 5), 10 );
			
			completed.dispatch();
		}
		
		private function listener0():void
		{
			listenersCalled.push(arguments.callee);
			assertSame('this should be the first listener called', arguments.callee, listenersCalled[0]);
		}
		
		private function listener1():void
		{
			listenersCalled.push(arguments.callee);
			assertSame('this should be the second listener called', arguments.callee, listenersCalled[1]);
		}
		
		private function listener2():void
		{
			listenersCalled.push(arguments.callee);
			assertSame('this should be the third listener called', arguments.callee, listenersCalled[2]);
		}
		//////
		[Test]
		public function listeners_added_with_same_priority_should_be_called_in_order_added():void
		{
			completed.add( addAsync(listener0, 5), 10 );
			completed.add( addAsync(listener1, 5), 10 );
			completed.add( addAsync(listener2, 5), 10 );
			
			completed.dispatch();
		}
		
		
	}
}

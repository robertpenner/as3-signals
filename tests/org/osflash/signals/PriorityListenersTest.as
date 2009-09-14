package org.osflash.signals
{
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import org.osflash.signals.GenericEvent;

	public class PriorityListenersTest extends TestCase
	{
		public var completed:ISignal;
		private var listenersCalled:Array;

		public function PriorityListenersTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			completed = new Signal(this);
			listenersCalled = [];
		}

		protected override function tearDown():void
		{
			completed.removeAll();
			completed = null;
			listenersCalled = null;
		}
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		//////
		public function test_listener_added_second_with_higher_priority_should_be_called_first():void
		{
			completed.add( addAsync(listener1) );
			completed.add( addAsync(listener0), 10 );
			
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
		public function test_listeners_added_with_same_priority_should_be_called_in_order_added():void
		{
			completed.add( addAsync(listener0), 10 );
			completed.add( addAsync(listener1), 10 );
			completed.add( addAsync(listener2), 10 );
			
			completed.dispatch();
		}
		
		
	}
}

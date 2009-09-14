package org.osflash.signals
{
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import org.osflash.signals.GenericEvent;

	public class PriorityListenersTest extends TestCase
	{
		public var completed:ISignal;
		private var methodsCalled:Array;

		public function PriorityListenersTest(testMethod:String = null)
		{
			super(testMethod);
			methodsCalled = [];
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
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		//////
		public function test_listener_added_second_with_higher_priority_should_be_called_first():void
		{
			//completed.add( addAsync(normalPriorityListener) );
			//completed.add( addAsync(higherPriorityListener, 1) );
			
			completed.add( (normalPriorityListener) );
			completed.add( (higherPriorityListener), 1 );
			completed.dispatch();
		}
		
		private function normalPriorityListener():void
		{
			methodsCalled.push(arguments.callee);
			assertSame('this should be the second method called', arguments.callee, methodsCalled[1]);
		}
		
		private function higherPriorityListener():void
		{
			methodsCalled.push(arguments.callee);
			assertSame('this should be the first method called', arguments.callee, methodsCalled[0]);
		}
	}
}

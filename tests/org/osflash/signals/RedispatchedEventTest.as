package org.osflash.signals {
	import asunit.framework.TestCase;
	import org.osflash.signals.GenericEvent;

	public class RedispatchedEventTest extends TestCase
	{
		public var completed:ISignal;
		protected var originalEvent:GenericEvent;

		public function RedispatchedEventTest(testMethod:String = null)
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
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		//////
		public function test_dispatch_event_already_dispatched_should_clone_it():void
		{
			completed.add(addAsync(redispatchEvent));
			originalEvent = new GenericEvent();
			completed.dispatch(originalEvent);
		}
		
		private function redispatchEvent(e:GenericEvent):void
		{
			e.signal.removeAll();
			assertSame(originalEvent, e);
			completed.add(addAsync(check_redispatched_event_is_not_original));
			
			completed.dispatch(originalEvent);
		}
		
		private function check_redispatched_event_is_not_original(e:GenericEvent):void
		{
			assertNotSame(originalEvent, e);
		}
	}
}

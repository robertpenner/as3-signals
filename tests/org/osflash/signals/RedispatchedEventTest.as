package org.osflash.signals {
	import asunit.asserts.*;
	import org.osflash.signals.GenericEvent;

	public class RedispatchedEventTest
	{
		public var completed:ISignal;
		protected var originalEvent:GenericEvent;

		public function RedispatchedEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		[Before]
		public function setUp():void
		{
			completed = new Signal(this);
		}

		[After]
		public function tearDown():void
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
		[Test]
		public function dispatch_event_already_dispatched_should_clone_it():void
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

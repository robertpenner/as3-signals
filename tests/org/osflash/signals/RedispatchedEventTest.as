package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;

	public class RedispatchedEventTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		public var completed:DeluxeSignal;
		protected var originalEvent:GenericEvent;

		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		[Test]
		public function dispatch_event_already_dispatched_should_clone_it():void
		{
			completed.add(async.add(redispatchEvent, 10));
			originalEvent = new GenericEvent();
			completed.dispatch(originalEvent);
		}
		
		private function redispatchEvent(e:GenericEvent):void
		{
			DeluxeSignal(e.signal).removeAll();
			assertSame(originalEvent, e);
			completed.add(async.add(check_redispatched_event_is_not_original, 10));
			
			completed.dispatch(originalEvent);
		}
		
		private function check_redispatched_event_is_not_original(e:GenericEvent):void
		{
			assertNotSame(originalEvent, e);
		}
	}
}

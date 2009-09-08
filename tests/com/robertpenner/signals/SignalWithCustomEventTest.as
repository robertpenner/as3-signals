package com.robertpenner.signals {
	import asunit.framework.TestCase;

	public class SignalWithCustomEventTest extends TestCase
	{
		public var message:Signal;

		public function SignalWithCustomEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			message = new Signal(this, MessageEvent);
		}

		protected override function tearDown():void
		{
			message.removeAll();
			message = null;
		}
		//////
		public function test_eventClass_roundtrips_through_constructor():void
		{
			assertSame(MessageEvent, message.eventClass);
		}
		
		public function test_add_one_listener_and_dispatch():void
		{
			message.add(addAsync(onMessage, 50));
			message.dispatch(new MessageEvent('ok'));
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			assertEquals('source of the event', message, e.signal);
			assertEquals('target of the event', this, e.target);
			assertEquals('message value in the event', 'ok', e.message);
		}
		//////
		public function test_dispatch_wrong_event_type_should_throw_TypeError():void
		{
			assertThrows(TypeError, dispatchWrongEventType);
		}
		
		private function dispatchWrongEventType():void
		{
			message.dispatch(new GenericEvent());
		}
		
		
	}
}

////// PRIVATE CLASSES //////

import com.robertpenner.signals.GenericEvent;
import com.robertpenner.signals.IEvent;

class MessageEvent extends GenericEvent implements IEvent
{
	public var message:String;
	
	public function MessageEvent(message:String)
	{
		super();
		this.message = message;
	}
	
	override public function clone():IEvent
	{
		return new MessageEvent(message);
	}
	
}


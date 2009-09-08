package com.robertpenner.signals {
	import asunit.framework.TestCase;

	public class SignalWithCustomEventTest extends TestCase
	{
		public var messaged:Signal;

		public function SignalWithCustomEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			messaged = new Signal(this, MessageEvent);
		}

		protected override function tearDown():void
		{
			messaged.removeAll();
			messaged = null;
		}
		//////
		public function test_eventClass_roundtrips_through_constructor():void
		{
			assertSame(MessageEvent, messaged.eventClass);
		}
		
		public function test_add_one_listener_and_dispatch():void
		{
			messaged.add(addAsync(onMessage, 50));
			messaged.dispatch(new MessageEvent('ok'));
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			assertEquals('source of the event', messaged, e.signal);
			assertEquals('target of the event', this, e.target);
			assertEquals('message value in the event', 'ok', e.message);
		}
		//////
		public function test_dispatch_wrong_event_type_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, dispatchWrongEventType);
		}
		
		private function dispatchWrongEventType():void
		{
			messaged.dispatch(new GenericEvent());
		}
		//////
		public function test_signal_with_eventClass_adding_listener_without_args_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, addListenerWithoutArgs);
		}
		
		private function addListenerWithoutArgs():void
		{
			messaged.add(noArgs);
		}
		
		private function noArgs():void
		{
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


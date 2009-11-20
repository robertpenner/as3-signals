package org.osflash.signals {
	import asunit.asserts.*;
	import asunit4.async.addAsync;
	import org.osflash.signals.events.GenericEvent;

	public class SignalWithCustomEventTest
	{
		public var messaged:ISignal;

		[Before]
		public function setUp():void
		{
			messaged = new Signal(this, MessageEvent);
		}

		[After]
		public function tearDown():void
		{
			messaged.removeAll();
			messaged = null;
		}
		//////
		[Test]
		public function eventClass_roundtrips_through_constructor():void
		{
			assertSame(MessageEvent, messaged.eventClass);
		}
		
		[Test(async)]
		public function add_one_listener_and_dispatch():void
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
		[Test]
		public function dispatch_wrong_event_type_should_throw_ArgumentError():void
		{
			assertThrows(ArgumentError, dispatchWrongEventType);
		}
		
		private function dispatchWrongEventType():void
		{
			messaged.dispatch(new GenericEvent());
		}
		//////
		[Test]
		public function signal_with_eventClass_adding_listener_without_args_should_throw_ArgumentError():void
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

import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.events.IEvent;

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


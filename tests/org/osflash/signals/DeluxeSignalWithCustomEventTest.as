package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	import org.osflash.signals.events.GenericEvent;

	public class DeluxeSignalWithCustomEventTest
	{
		public var messaged:DeluxeSignal;

		[Before]
		public function setUp():void
		{
			messaged = new DeluxeSignal(this, MessageEvent);
		}

		[After]
		public function tearDown():void
		{
			messaged.removeAll();
			messaged = null;
		}
		//////
		[Test]
		public function valueClasses_roundtrip_through_constructor():void
		{
			assertSame(MessageEvent, messaged.valueClasses[0]);
		}
		
		[Test]
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
		[Test(expects="ArgumentError")]
		public function dispatch_wrong_event_type_should_throw_ArgumentError():void
		{
			messaged.dispatch(new GenericEvent());
		}

		[Test(expects="ArgumentError")]
		public function signal_with_eventClass_adding_listener_without_args_should_throw_ArgumentError():void
		{
			messaged.add(function():void {});
		}
	}
}

import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.events.IEvent;

////// PRIVATE CLASSES //////


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


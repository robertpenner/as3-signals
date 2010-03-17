package org.osflash.signals
{
	import asunit.asserts.*;

	import asunit4.async.addAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IBubbleEventHandler;
	import org.osflash.signals.events.IEvent;

	public class DeluxeSignalWithBubblingEventTest implements IBubbleEventHandler
	{
		protected var theChild:Child;
		protected var theGrandChild:Child;
		protected var cancelTimeout:Function;

		[Before]
		public function setUp():void
		{
			theChild = new Child('theChild', this);
			theGrandChild = new Child('theGrandChild', theChild);
		}

		[After]
		public function tearDown():void
		{
			theChild = null;
			theGrandChild = null;
		}
		
		[Test]
		public function parent_child_relationships():void
		{
			assertSame("theChild's parent is this", this, theChild.parent);
			assertTrue("this can handle bubbling events", this is IBubbleEventHandler);
		}
		//////
		[Test]
		public function dispatch_bubbling_event_from_theGrandChild_should_bubble_to_IBubbleHandler():void
		{
			cancelTimeout = addAsync(null, 10);
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			theGrandChild.completed.dispatch(event); // event.target will be child
		}
		
		public function onEventBubbled(e:IEvent):void
		{
			cancelTimeout();
			cancelTimeout = null;
			assertSame('e.target should be the object that originally dispatched event', theGrandChild, e.target);
			assertSame('e.currentTarget should be the object receiving the bubbled event', this, e.currentTarget);
		}
	}
}

import org.osflash.signals.DeluxeSignal;

////// PRIVATE CLASSES //////


class Child
{
	public var parent:Object;
	public var completed:DeluxeSignal;
	public var name:String;
	
	public function Child(name:String, parent:Object = null)
	{
		this.name = name;
		this.parent = parent;
		completed = new DeluxeSignal(this);
	}
	
	public function toString():String
	{
		return '[Child '+name+']';
	}
}

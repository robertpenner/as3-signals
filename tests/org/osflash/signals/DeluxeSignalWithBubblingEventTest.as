package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IBubbleEventHandler;
	import org.osflash.signals.events.IEvent;

	public class DeluxeSignalWithBubblingEventTest implements IBubbleEventHandler
	{
	    [Inject]
	    public var async:IAsync;
	
		protected var theParent:IBubbleEventHandler;
		protected var theChild:Child;
		protected var theGrandChild:Child;
		protected var cancelTimeout:Function;

		[Before]
		public function setUp():void
		{
			theParent = this;
			theChild = new Child(this, 'theChild');
			theGrandChild = new Child(theChild, 'theGrandChild');
		}

		[After]
		public function tearDown():void
		{
			theChild = null;
			theGrandChild = null;
			cancelTimeout = null;
		}
		
		[Test]
		public function parent_child_relationships():void
		{
			assertSame("theChild's parent is this", this, theChild.parent);
			assertTrue("this can handle bubbling events", this is IBubbleEventHandler);
		}

		[Test]
		public function dispatch_bubbling_event_from_theGrandChild_should_bubble_to_parent_IBubbleHandler():void
		{
			// If cancelTimeout() isn't called, this test will fail.
			cancelTimeout = async.add(null, 10);
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			theGrandChild.completed.dispatch(event);
		}
		
		public function onEventBubbled(e:IEvent):Boolean
		{
			cancelTimeout();
			assertSame('e.target should be the object that originally dispatched event', theGrandChild, e.target);
			assertSame('e.currentTarget should be the object receiving the bubbled event', this, e.currentTarget);
			return false;
		}
		
		[Test]
		public function returning_false_from_onEventBubbled_should_stop_bubbling():void
		{
			var bubbleHater:BubbleHater = new BubbleHater();
			theChild = new Child(bubbleHater, 'bubblePopper');
			theChild.popsBubbles = true;
			theGrandChild = new Child(theChild, 'bubbleBlower');
			
			var bubblingEvent:IEvent = new GenericEvent(true);
			// Will only complete without error if theChild pops the bubble.
			theGrandChild.completed.dispatch(bubblingEvent);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function returning_true_from_onEventBubbled_should_continue_bubbling():void
		{
			var bubbleHater:BubbleHater = new BubbleHater();
			theChild = new Child(bubbleHater, 'bubblePopper');
			// Changing popsBubbles to false will fail the test nicely.
			theChild.popsBubbles = false;
			theGrandChild = new Child(theChild, 'bubbleBlower');
			
			var bubblingEvent:IEvent = new GenericEvent(true);
			// Because theChild didn't pop the bubble, this causes bubbleHater to throw an error.
			theGrandChild.completed.dispatch(bubblingEvent);
		}
	}
}

import org.osflash.signals.DeluxeSignal;
import org.osflash.signals.events.IBubbleEventHandler;
import org.osflash.signals.events.IEvent;

import flash.errors.IllegalOperationError;

class Child implements IBubbleEventHandler
{
	public var parent:Object;
	public var completed:DeluxeSignal;
	public var name:String;
	public var popsBubbles:Boolean = false;
	
	public function Child(parent:Object = null, name:String = '')
	{
		this.parent = parent;
		this.name = name;
		completed = new DeluxeSignal(this);
	}
	
	public function toString():String
	{
		return '[Child '+name+']';
	}
	
	public function onEventBubbled(event:IEvent):Boolean
	{
		return !popsBubbles;
	}
}

class BubbleHater implements IBubbleEventHandler
{
	public function onEventBubbled(event:IEvent):Boolean
	{
		throw new IllegalOperationError('I SAID NO BUBBLES!!!');
		return false;
	}
}

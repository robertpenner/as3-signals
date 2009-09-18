package org.osflash.signals {
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import org.osflash.signals.GenericEvent;
	import org.osflash.signals.Signal;

	public class SignalWithBubblingEventTest extends TestCase implements IBubbleEventHandler
	{
		protected var theChild:Child;
		protected var theGrandChild:Child;
		protected var cancelTimeout:Function;

		public function SignalWithBubblingEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			theChild = new Child('theChild', this);
			theGrandChild = new Child('theGrandChild', theChild);
		}

		protected override function tearDown():void
		{
			//theChild = null; //This happens too soon and messes up the test--probably an ASUnit bug.
		}
		
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		
		public function test_parent_child_relationships():void
		{
			assertSame("theChild's parent is this", this, theChild.parent);
			assertTrue("this can handle bubbling events", this is IBubbleEventHandler);
		}
		//////
		public function test_dispatch_bubbling_event_from_theGrandChild_should_bubble_to_IBubbleHandler():void
		{
			cancelTimeout = addAsync();
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

////// PRIVATE CLASSES //////

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

class Child
{
	public var parent:Object;
	public var completed:ISignal;
	public var name:String;
	
	public function Child(name:String, parent:Object = null)
	{
		this.name = name;
		this.parent = parent;
		completed = new Signal(this);
	}
	
	public function toString():String
	{
		return '[Child '+name+']';
	}
}

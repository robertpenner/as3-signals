package com.robertpenner.signals {
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import com.robertpenner.signals.GenericEvent;
	import com.robertpenner.signals.Signal;

	public class SignalWithBubblingEventTest extends TestCase
	{
		protected var theChild:Container;
		protected var theParent:Container;
		protected var theGrandParent:Container;

		public function SignalWithBubblingEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			theChild = new Container('theChild');
			theParent = new Container('theParent', theChild);
			theGrandParent = new Container('theGrandParent', theParent);
		}

		protected override function tearDown():void
		{
			if (theParent)
			{
				theParent.child = null; // break circular reference
				theParent.complete.removeAll();
				theParent = null;
			}
		}
		
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		
		public function test_parent_child_relationships():void
		{
			assertSame("theParent's child is theChild", theChild, theParent.child);
			assertSame("theChild's parent is theParent", theParent, theChild.parent);
		}
		//////
		public function test_listen_to_parent_and_dispatch_bubbling_event_from_theChild_should_bubble_to_parent():void
		{
			theParent.complete.addOnce( addAsync(onParentComplete) ); // will be event.currentTarget
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			theChild.complete.dispatch(event); // event.target will be child
		}
		
		private function onParentComplete(e:GenericEvent):void
		{
			assertSame('e.target should be the object that originally dispatched event', theChild, e.target);
			assertSame('e.currentTarget should be the object that added this listener', theParent, e.currentTarget);
			assertSame('e.signal should be signal that added this listener', theParent.complete, e.signal);
		}
		//////
		public function test_listen_to_grandparent_and_dispatch_bubbling_event_from_child_should_bubble_to_grandparent():void
		{
			theGrandParent.complete.addOnce( addAsync(onGrandParentComplete) );
			
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			theChild.complete.dispatch(event);
		}
		
		private function onGrandParentComplete(e:GenericEvent):void
		{
			assertSame('e.target should be the object that originally dispatched event', theChild, e.target);
			assertSame('e.currentTarget should be the object that added this listener', theGrandParent, e.currentTarget);
			assertSame('e.signal should be signal that added this listener', theGrandParent.complete, e.signal);
		}
		//////
		public function test_listen_to_container_and_theChild_and_dispatch_bubbling_event_from_theChild_should_trigger_both():void
		{
			theParent.complete.addOnce( addAsync(onParentComplete) );
			theChild.complete.addOnce( addAsync(onChildComplete) );
			
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			theChild.complete.dispatch(event);
		}
		
		private function onChildComplete(e:GenericEvent):void
		{
			assertSame('e.target should be the object that originally dispatched event', theChild, e.target);
			assertSame('e.currentTarget should be the object that added this listener', theChild, e.currentTarget);
			assertSame('e.signal should be signal that added this listener', theChild.complete, e.signal);
		}
		
	}
}

////// PRIVATE CLASSES //////

import com.robertpenner.signals.ISignal;
import com.robertpenner.signals.Signal;
import com.robertpenner.signals.IEventBubbler;
import com.robertpenner.signals.IEvent;
import flash.display.DisplayObject;
import flash.display.Sprite;

dynamic class Container implements IEventBubbler
{
	public var parent:Object;
	public var child:Object;
	public var complete:ISignal;
	public var name:String;
	
	public function Container(name:String, child:Object = null)
	{
		this.name = name;
		if (child)
		{
			this.child = child;
			child.parent = this;
		}
		complete = new Signal(this);
	}
	
	public function onEventBubbled(event:IEvent):void
	{
		complete.dispatch(event);
	}
	
	public function toString():String
	{
		return '[Container '+name+']';
	}
}

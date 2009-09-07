package com.robertpenner.signals {
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import com.robertpenner.signals.GenericEvent;
	import com.robertpenner.signals.Signal;

	public class SignalWithBubblingEventTest extends TestCase
	{
		protected var container:Container;
		protected var child:Child;

		public function SignalWithBubblingEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			child = new Child();
			container = new Container(child);
		}

		protected override function tearDown():void
		{
			container.child = null; // break circular reference
			container = null;
		}
		
		// This is a convenience override to set the async timeout really low, so failures happen more quickly.
		override protected function addAsync(handler:Function = null, duration:Number = 10, failureHandler:Function=null):Function
		{
			return super.addAsync(handler, duration, failureHandler);
		}
		
		public function test_parent_child_relationships():void
		{
			assertSame("container's child is child", child, container.child);
			assertSame("child's parent is container", container, child.parent);
		}
		//////
		public function test_listen_to_container_and_dispatch_bubbling_event_from_child_should_bubble_to_container():void
		{
			container.complete.addOnce(addAsync(onContainerComplete)); // will be event.currentTarget
			
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			child.complete.dispatch(event); // will be event.target
		}
		
		private function onContainerComplete(e:GenericEvent):void
		{
			assertSame('e.signal should be signal that added this listener', container.complete, e.signal);
			assertSame('e.target should be the object that originally dispatched event', child, e.target);
			assertSame('e.currentTarget should be the object that added this listener', container, e.currentTarget);
		}
		//////
		public function test_listen_to_container_and_child_and_dispatch_bubbling_event_from_child_should_not_bubble_to_container():void
		{
			container.complete.addOnce(failIfCalled);
			child.complete.addOnce( addAsync(onChildComplete) );
			
			var event:IEvent = new GenericEvent();
			event.bubbles = true;
			
			child.complete.dispatch(event);
		}
		
		private function failIfCalled(e:IEvent):void
		{
			fail('This event handler should not have been called.');
		}
		
		private function onChildComplete(e:GenericEvent):void
		{
			assertSame('e.signal should be signal that added this listener', child.complete, e.signal);
			assertSame('e.target should be the object that originally dispatched event', child, e.target);
			assertSame('e.currentTarget should be the object that added this listener', child, e.currentTarget);
		}
		//////
	}
}

////// PRIVATE CLASSES //////

import com.robertpenner.signals.Signal;
import com.robertpenner.signals.IEventBubbler;
import com.robertpenner.signals.IEvent;

class Container implements IEventBubbler
{
	public var child:Child;
	public var complete:Signal;
	
	public function Container(child:Child)
	{
		this.child = child;
		child.parent = this;
		complete = new Signal(this);
	}
	
	public function onEventBubbled(event:IEvent):void
	{
		complete.dispatch(event);
	}
}

class Child
{
	public var complete:Signal;
	public var parent:*;
	
	public function Child()
	{
		complete = new Signal(this);
	}
}

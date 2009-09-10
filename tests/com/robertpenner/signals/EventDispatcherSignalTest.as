package com.robertpenner.signals
{
	import asunit.framework.TestCase;
	import flash.events.MouseEvent;

	public class EventDispatcherSignalTest extends TestCase
	{
		private var click:ISignal;

		public function EventDispatcherSignalTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			click = new EventDispatcherSignal(this, 'click', MouseEvent);
		}

		protected override function tearDown():void
		{
			click.removeAll();
			click = null;
		}

		public function testInstantiated():void
		{
			assertTrue("EventDispatcherSignal instantiated", click is EventDispatcherSignal);
			assertTrue('implements ISignal', click is ISignal);
		}
		//////
		public function test_signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			click.add( addAsync(onClicked, 10) );
			dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(this, e.currentTarget);
		}
		//////
		public function test_when_signal_add_listener_then_hasEventListener_should_be_true():void
		{
			click.add(emptyHandler);
			assertTrue(hasEventListener('click'));
		}
		
		private function emptyHandler(e:*):void	{}
		
		public function test_when_signal_add_then_remove_listener_then_hasEventListener_should_be_false():void
		{
			click.add(emptyHandler);
			click.remove(emptyHandler);
			assertFalse(hasEventListener('click'));
		}
		//////
	}
}

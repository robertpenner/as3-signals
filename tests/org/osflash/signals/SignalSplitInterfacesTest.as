package org.osflash.signals
{
	import asunit.asserts.*;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.IListeners;
	import org.osflash.signals.Signal;

	public class SignalSplitInterfacesTest
	{
		// Notice the use of the smaller ISubscriber interface, rather than ISignal.
		// This makes dispatch() inaccessible unless the Signal is cast to IDispatcher.
		public var completed:IListeners;

		public function SignalSplitInterfacesTest(testMethod:String = null)
		{
			super(testMethod);
		}

		[Before]
		public function setUp():void
		{
			completed = new Signal(this);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		[Test]
		public function cast_to_IDispatcher_and_dispatch_should_work():void
		{
			completed.addOnce( addAsync(onCompleted, 10) );
			IDispatcher(completed).dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		
	}
}

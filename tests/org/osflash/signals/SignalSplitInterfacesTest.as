package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit4.async.addAsync;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.IListeners;
	import org.osflash.signals.Signal;

	public class SignalSplitInterfacesTest
	{
		// Notice the use of the smaller IListeners interface, rather than ISignal.
		// This makes dispatch() inaccessible unless the Signal is typed to IDispatcher.
		public var completed:IListeners;

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
		[Test(async)]
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

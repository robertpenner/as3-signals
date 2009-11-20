package org.osflash.signals.simple
{
	import asunit.asserts.*;
	import asunit4.async.addAsync;
	import org.osflash.signals.IDispatcher;

	public class SimpleSignalSplitInterfacesTest
	{
		// Notice the use of the smaller ISimpleListeners interface, rather than ISimpleSignal.
		// This makes dispatch() inaccessible unless the SimpleSignal is typed to IDispatcher.
		public var completed:ISimpleListeners;

		[Before]
		public function setUp():void
		{
			completed = new SimpleSignal(this);
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

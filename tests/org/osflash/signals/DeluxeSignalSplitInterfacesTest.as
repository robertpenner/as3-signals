package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class DeluxeSignalSplitInterfacesTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		// Notice the use of the smaller IListeners interface, rather than ISignal.
		// This makes dispatch() inaccessible unless the Signal is typed to IDispatcher.
		public var completed:IDeluxeSignal;

		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
		}

		[After]
		public function tearDown():void
		{
			DeluxeSignal(completed).removeAll();
			completed = null;
		}
		//////
		[Test]
		public function cast_to_IDispatcher_and_dispatch_should_work():void
		{
			completed.addOnce( async.add(onCompleted, 10) );
			IDispatcher(completed).dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		
	}
}

package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class SignalSplitInterfacesTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		// Notice the use of the ISignal interface, rather than Signal.
		// This makes dispatch() inaccessible unless the ISignal is cast to IDispatcher or Signal.
		public var completed:ISignal;

		[Before]
		public function setUp():void
		{
			completed = new Signal();
		}

		[After]
		public function tearDown():void
		{
			Signal(completed).removeAll();
			completed = null;
		}
		
		[Test]
		public function cast_ISignal_to_IDispatcher_and_dispatch():void
		{
			completed.addOnce( async.add(onCompleted, 10) );
			IDispatcher(completed).dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		
		[Test]
		public function cast_ISignal_to_Signal_and_dispatch():void
		{
			completed.addOnce( async.add(onCompleted, 10) );
			Signal(completed).dispatch();
		}
	}
}

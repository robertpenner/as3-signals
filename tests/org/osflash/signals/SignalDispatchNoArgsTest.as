package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class SignalDispatchNoArgsTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		public var signal:ISignal;

		[Before]
		public function setUp():void
		{
			signal = new Signal();
		}

		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
		}
		//////
		[Test]
		public function dispatch_no_args_should_call_listener_with_no_args():void
		{
			signal.add( async.add(onCompleted, 10) );
			signal.dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		//////
		[Test]
		public function addOnce_in_handler_and_dispatch_should_call_new_listener():void
		{
			signal.addOnce( async.add(addOnceInHandler, 10) );
			signal.dispatch();
		}
		
		protected function addOnceInHandler():void
		{
			signal.addOnce( async.add(secondAddOnceListener, 10) );
			signal.dispatch();
		}
		
		protected function secondAddOnceListener():void
		{
		}
	}
}

package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.framework.IAsync;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class MonoSignalDispatchNoArgsTest
	{
		[Inject]
	    public var async:IAsync;
	    
		public var completed:MonoSignal;

		[Before]
		public function setUp():void
		{
			completed = new MonoSignal();
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		[Test]
		public function dispatch_no_args_should_call_listener_with_no_args():void
		{
			completed.add( async.add(onCompleted, 10) );
			completed.dispatch();
		}
		
		private function onCompleted():void
		{
			assertEquals(0, arguments.length);
		}
		//////
		[Test]
		public function addOnce_in_handler_and_dispatch_should_call_new_listener():void
		{
			completed.addOnce( async.add(addOnceInHandler, 10) );
			completed.dispatch();
		}
		
		protected function addOnceInHandler():void
		{
			completed.addOnce( async.add(secondAddOnceListener, 10) );
			completed.dispatch();
		}
		
		protected function secondAddOnceListener():void
		{
		}
	}
}

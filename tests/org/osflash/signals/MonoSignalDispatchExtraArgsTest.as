package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertTrue;
	import asunit.framework.IAsync;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class MonoSignalDispatchExtraArgsTest
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
		public function dispatch_extra_args_should_call_listener_with_extra_args():void
		{
			completed.add( async.add(onCompleted, 10) );
			completed.dispatch(22, 'done', new Date());
		}

		private function onCompleted(a:uint, b:String, c:Date):void
		{
			assertEquals(3, arguments.length);
			assertEquals(22, a);
			assertEquals('done', b);
			assertTrue(c is Date);
		}
	}
}

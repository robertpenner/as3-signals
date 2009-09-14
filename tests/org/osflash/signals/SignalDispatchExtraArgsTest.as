package org.osflash.signals
{
	import asunit.framework.TestCase;
	import org.osflash.signals.ISignal;

	public class SignalDispatchExtraArgsTest extends TestCase
	{
		public var completed:ISignal;

		public function SignalDispatchExtraArgsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			completed = new Signal(this);
		}

		protected override function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		//////
		public function test_dispatch_extra_args_should_call_listener_with_extra_args():void
		{
			completed.add( addAsync(onCompleted, 10) );
			completed.dispatch(22, 'done', new Date());
		}
		
		private function onCompleted(...args:Array):void
		{
			assertEquals(3, args.length);
			assertEquals(22, args[0]);
			assertEquals('done', args[1]);
			assertTrue(args[2] is Date);
		}
		//////
		
	}
}

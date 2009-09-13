package org.osflash.signals
{
	import asunit.framework.TestCase;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.IListenerManager;
	import org.osflash.signals.Signal;

	public class SignalSplitInterfacesTest extends TestCase
	{
		// Notice the use of the smaller ISubscriber interface, rather than ISignal.
		// This makes dispatch() inaccessible unless the Signal is cast to IDispatcher.
		public var completed:IListenerManager;

		public function SignalSplitInterfacesTest(testMethod:String = null)
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
		public function test_cast_to_IDispatcher_and_dispatch_should_work():void
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

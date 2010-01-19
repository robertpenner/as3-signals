package org.osflash.signals {
	import asunit.asserts.assertEquals;

	public class DeluxeSignalTest {
		private var completed:DeluxeSignal;
		
		[Before]
		public function setUp():void
		{
			completed = new DeluxeSignal(this);
		}
		
		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}

		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			completed.add(newEmptyHandler());
			completed.remove(newEmptyHandler());
			assertEquals(1, completed.numListeners);
		}
		
		private function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
	}
}
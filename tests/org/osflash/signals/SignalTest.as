package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	import flash.display.Sprite;

	public class SignalTest extends ISignalTestBase
	{
		[Before]
		public function setUp():void
		{
			signal = new Signal();
		}

		[Test]
		public function dispatch_should_pass_event_to_listener_but_not_set_signal_or_target_properties():void
		{
			signal.add(async.add(checkGenericEvent, 10));
			signal.dispatch(new GenericEvent());
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}		
		
		[Test]
		public function dispatch_non_IEvent_without_error():void
		{
			signal.addOnce(checkSprite);
			// Sprite doesn't have a target property,
			// so if the signal tried to set .target,
			// an error would be thrown and this test would fail.
			signal.dispatch(new Sprite());
		}
		
		private function checkSprite(sprite:Sprite):void
		{
			assertTrue(sprite is Sprite);
		}
		
		[Test]
		public function removed_listener_should_return_binding():void
		{
			var listener:Function = function():void{};
			var binding:ISignalBinding = signal.add(listener);
			
			assertTrue("Binding is returned", binding == signal.remove(listener));
		}
		
		[Test]
		public function removed_listener_should_be_returned():void
		{
			var binding:ISignalBinding = signal.add(function():void{});
			var listener:Function = binding.listener;
			
			assertTrue("Binding is returned", binding == signal.remove(listener));
		}
		
		/////
		
		[Test]
		public function verify_redispatch_of_signal_with_no_valueClasses() : void
		{
			const redispatch:Signal = new Signal();
			redispatch.add(checkGenericEvent);
			
			signal.add(redispatch.dispatch);
			signal.dispatch(new GenericEvent());
		}
				
		[Test(expects='ArgumentError')]
		public function verify_redispatch_of_signal() : void
		{
			const redispatch:Signal = new Signal();
			redispatch.add(checkGenericEvent);
			
			signal = new Signal(GenericEvent);
			signal.add(redispatch.dispatch);
			signal.dispatch(new GenericEvent());
		}	
	}
}

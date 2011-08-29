package org.osflash.signals
{
	import asunit.asserts.*;

	import org.osflash.signals.events.GenericEvent;

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
		public function adding_dispatch_method_as_listener_does_not_throw_error():void
		{
			const redispatchSignal:Signal = new Signal(GenericEvent);
			signal = new Signal(GenericEvent);
			signal.add(redispatchSignal.dispatch);
		}	
		
		[Test]
		public function slot_params_should_be_sent_through_to_listener():void
		{
			var listener:Function = function(number:int, string:String, sprite:Sprite):void
									{ 
										assertEquals(number, 12345);
										assertEquals(string, 'text');
										assertEquals(sprite, slot.params[2]);
									};

			var slot:ISlot = signal.add(async.add(listener));
			slot.params = [12345, 'text', new Sprite()];

			signal.dispatch();
		}
		
		[Test]
		public function slot_params_with_with_10_params_should_be_sent_through_to_listener():void
		{
			// Test the function.apply - maying sure we get everything we ask for.
			var listener:Function = function(
												number:int, 
												string:String, 
												sprite:Sprite,
												alpha0:String,
												alpha1:String,
												alpha2:String,
												alpha3:String,
												alpha4:String,
												alpha5:String,
												alpha6:String
												):void
									{ 
										assertEquals(number, 12345);
										assertEquals(string, 'text');
										assertEquals(sprite, slot.params[2]);
										assertEquals(alpha0, 'a');
										assertEquals(alpha1, 'b');
										assertEquals(alpha2, 'c');
										assertEquals(alpha3, 'd');
										assertEquals(alpha4, 'e');
										assertEquals(alpha5, 'f');
										assertEquals(alpha6, 'g');
									};

			var slot:ISlot = signal.add(async.add(listener));
			slot.params = [12345, 'text', new Sprite(), "a", "b", "c", "d", "e", "f", "g"];

			signal.dispatch();
		}
	}
}

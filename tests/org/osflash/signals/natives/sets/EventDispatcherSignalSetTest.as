package org.osflash.signals.natives.sets
{
	import org.osflash.signals.ISlot;
	import asunit.asserts.fail;
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.framework.IAsync;

	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class EventDispatcherSignalSetTest
	{
		
		[Inject]
		public var async:IAsync;
		
		private var sprite:Sprite;
		
		private var signalSet:EventDispatcherSignalSet;

		[Before]
		public function setUp():void 
		{
			sprite = new Sprite();
			signalSet = new EventDispatcherSignalSet(sprite);
		}

		[After]
		public function tearDown():void 
		{
			signalSet.removeAll();
			signalSet = null;
			sprite = null;
		}
		
		
		protected function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		
		private function handleEvent(event:Event):void
		{
			assertSame(sprite, event.target);
		}
		
		protected function failIfCalled(e:Event):void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function numListeners_should_be_zero():void
		{
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function signals_should_be_not_null():void
		{
			assertNotNull('Signals should not be null.', signalSet.signals);
		}
		
		//////
		
		[Test]
		public function signals_length_should_be_empty():void
		{
			assertTrue('Signals length should be 0.', signalSet.signals.length == 0);
		}
		
		//////
		
		[Test]
		public function signals_length_should_be_zero_after_removeAll():void
		{
			signalSet.removeAll();
			
			assertTrue('Signals length should be 0.', signalSet.signals.length == 0);
		}
		
		//////
		
		[Test]
		public function numListeners_should_be_zero_after_removeAll():void
		{
			signalSet.removeAll();
			
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function activate_signal_should_not_be_null():void
		{
			assertNotNull('Activate NativeSignal should not be null', signalSet.activate);
		}
		
		//////
		
		[Test]
		public function deactivate_signal_should_not_be_null():void
		{
			assertNotNull('Deactivate NativeSignal should not be null', signalSet.deactivate);
		}
		
		//////
		
		[Test]
		public function add_activate_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.activate.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.ACTIVATE));
		}

		//////
		
		[Test]
		public function add_deactivate_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.deactivate.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.DEACTIVATE));
		}
		
		//////
		
		[Test]
		public function add_activate_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.activate.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		//////
		
		[Test]
		public function add_deactivate_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.deactivate.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.DEACTIVATE));
		}
		
		//////
		
		[Test]
		public function add_activate_then_numListeners_should_be_one():void
		{
			signalSet.activate.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_deactivate_then_numListeners_should_be_one():void
		{
			signalSet.deactivate.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_too_both_signals_then_numListeners_should_be_two():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			assertTrue('Number of listeners should be 2', signalSet.numListeners == 2);
		}	
		
		[Test]
		public function add_too_both_signals_then_remove_activate_numListeners_should_be_one():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.activate.removeAll();
			
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}		
		
		[Test]
		public function add_too_both_signals_then_remove_deactivate_numListeners_should_be_one():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.deactivate.removeAll();
			
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		[Test]
		public function add_too_both_signals_then_removeAll_numListeners_should_be_zero():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.removeAll();
			
			assertTrue('Number of listeners should be 0', signalSet.numListeners == 0);
		}
	}
}

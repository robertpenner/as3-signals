package org.osflash.signals.natives.sets
{
	import flash.events.Event;
	import org.osflash.signals.natives.NativeSignal;
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertTrue;
	import asunit.framework.IAsync;

	import flash.display.Sprite;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class NativeSignalSetTest
	{
		
		[Inject]
		public var async:IAsync;
		
		private var sprite:Sprite;
		
		private var signalSet:NativeSignalSet;

		[Before]
		public function setUp():void 
		{
			sprite = new Sprite();
			signalSet = new NativeSignalSet(sprite);
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
		public function getNativeSignal_should_return_NativeSignal():void
		{
			const result:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			assertTrue('getNativeSignal should return type NativeSignal.', result is NativeSignal);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_should_not_throw_Error_when_null_is_used_as_classType():void
		{
			signalSet.getNativeSignal(Event.INIT, null);
		}
		
		//////
		
		[Test(expects='ArgumentError')]
		public function getNativeSignal_should_throw_Error_when_used_for_event_type():void
		{
			signalSet.getNativeSignal(null);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_should_increment_num_signals_to_one():void
		{
			signalSet.getNativeSignal(Event.INIT);
			
			assertTrue('Number of Signals should be 1', signalSet.signals.length == 1);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_with_same_event_type_should_have_signal_length_of_one():void
		{
			signalSet.getNativeSignal(Event.INIT);
			signalSet.getNativeSignal(Event.INIT);
			
			assertTrue('Number of Signals should be 1', signalSet.signals.length == 1);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_with_different_eventType_should_increment_num_signals_to_two():void
		{
			signalSet.getNativeSignal(Event.INIT);
			signalSet.getNativeSignal(Event.ACTIVATE);
			
			assertTrue('Number of Signals should be 2', signalSet.signals.length == 2);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_with_lots_of_different_eventType_should_increment_num_signals_to_100():void
		{
			for(var i:int = 0; i<100; i++)
			{
				signalSet.getNativeSignal("event" + i);
			}
			
			assertTrue('Number of Signals should be 100', signalSet.signals.length == 100);
		}
		
		//////
		
		[Test]
		public function get_lots_of_getNativeSignal_then_removeAll_should_have_zero_signals():void
		{
			for(var i:int = 0; i<100; i++)
			{
				signalSet.getNativeSignal("event" + i);
			}
			
			signalSet.removeAll();
			
			assertTrue('Number of Signals should be 0', signalSet.signals.length == 0);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_and_add_listener():void
		{
			const nativeSignal:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			nativeSignal.add(newEmptyHandler());
			
			assertTrue('Number of listeners should be 1.', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_and_add_10_listeners():void
		{
			const nativeSignal:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			
			for(var i:int = 0; i<10; i++)
			{
				nativeSignal.add(newEmptyHandler());
			}
			
			assertTrue('Number of listeners should be 10.', signalSet.numListeners == 10);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_and_add_10_listeners_and_removeAll():void
		{
			const nativeSignal:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			
			for(var i:int = 0; i<10; i++)
			{
				nativeSignal.add(newEmptyHandler());
			}
			
			signalSet.removeAll();
			
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function getNativeSignal_and_add_10_listeners_and_removeAll_from_signal():void
		{
			const nativeSignal:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			
			for(var i:int = 0; i<10; i++)
			{
				nativeSignal.add(newEmptyHandler());
			}
			
			nativeSignal.removeAll();
			
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function get_two_getNativeSignal_and_add_10_listeners_to_each():void
		{
			const nativeSignal0:NativeSignal = signalSet.getNativeSignal(Event.INIT);
			
			var i:int = 0;
			for(i = 0; i<10; i++)
			{
				nativeSignal0.add(newEmptyHandler());
			}
			
			const nativeSignal1:NativeSignal = signalSet.getNativeSignal(Event.CHANGE);
			
			for(i = 0; i<10; i++)
			{
				nativeSignal1.add(newEmptyHandler());
			}
			
			assertTrue('Number of listeners should be 20.', signalSet.numListeners == 20);
		}
		
		//////
	}
}

package org.osflash.signals.natives.sets
{
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.ISignalBinding;

	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class DisplayObjectSignalSetTest
	{
		
		[Inject]
		public var async:IAsync;
		
		private var sprite:Sprite;
		
		private var signalSet:DisplayObjectSignalSet;

		[Before]
		public function setUp():void 
		{
			sprite = new Sprite();
			signalSet = new DisplayObjectSignalSet(sprite);
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
		public function numListeners_should_be_zero() : void
		{
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
		
		//////
		
		[Test]
		public function signals_should_be_not_null() : void
		{
			assertNotNull('Signals should not be null.', signalSet.signals);
		}
		
		//////
		
		[Test]
		public function signals_length_should_be_empty() : void
		{
			assertTrue('Signals length should be 0.', signalSet.signals.length == 0);
		}
		
		//////
		
		[Test]
		public function signals_length_should_be_zero_after_removeAll() : void
		{
			signalSet.removeAll();
			
			assertTrue('Signals length should be 0.', signalSet.signals.length == 0);
		}
		
		//////
		
		[Test]
		public function numListeners_should_be_zero_after_removeAll() : void
		{
			signalSet.removeAll();
			
			assertTrue('Number of listeners should be 0.', signalSet.numListeners == 0);
		}
				
		//////
		
		[Test]
		public function added_signal_should_not_be_null() : void
		{
			assertNotNull('Added NativeSignal should not be null', signalSet.added);
		}
		
		//////
		
		[Test]
		public function addedToStage_signal_should_not_be_null() : void
		{
			assertNotNull('AddedToStage NativeSignal should not be null', signalSet.addedToStage);
		}
		
		//////
		
		[Test]
		public function enterFrame_signal_should_not_be_null() : void
		{
			assertNotNull('EnterFrame NativeSignal should not be null', signalSet.enterFrame);
		}
		
		//////
		
		[Test]
		public function exitFrame_signal_should_not_be_null() : void
		{
			assertNotNull('ExitFrame NativeSignal should not be null', signalSet.exitFrame);
		}
		
		//////
		
		[Test]
		public function frameConstructed_signal_should_not_be_null() : void
		{
			assertNotNull('FrameConstructed NativeSignal should not be null', signalSet.frameConstructed);
		}
		
		//////
		
		[Test]
		public function removed_signal_should_not_be_null() : void
		{
			assertNotNull('Removed NativeSignal should not be null', signalSet.removed);
		}
		
		//////
		
		[Test]
		public function removedFromStage_signal_should_not_be_null() : void
		{
			assertNotNull('RemovedFromStage NativeSignal should not be null', signalSet.removedFromStage);
		}
		
		//////
		
		[Test]
		public function render_signal_should_not_be_null() : void
		{
			assertNotNull('Render NativeSignal should not be null', signalSet.render);
		}
	}
}

package org.osflash.signals.natives.sets
{
	import asunit.asserts.assertNotNull;
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	import org.osflash.signals.ISlot;

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
		public function added_signal_should_not_be_null():void
		{
			assertNotNull('Added NativeSignal should not be null', signalSet.added);
		}
		
		//////
		
		[Test]
		public function addedToStage_signal_should_not_be_null():void
		{
			assertNotNull('AddedToStage NativeSignal should not be null', signalSet.addedToStage);
		}
		
		//////
		
		[Test]
		public function enterFrame_signal_should_not_be_null():void
		{
			assertNotNull('EnterFrame NativeSignal should not be null', signalSet.enterFrame);
		}
		
		//////
		
		[Test]
		public function exitFrame_signal_should_not_be_null():void
		{
			assertNotNull('ExitFrame NativeSignal should not be null', signalSet.exitFrame);
		}
		
		//////
		
		[Test]
		public function frameConstructed_signal_should_not_be_null():void
		{
			assertNotNull('FrameConstructed NativeSignal should not be null', signalSet.frameConstructed);
		}
		
		//////
		
		[Test]
		public function removed_signal_should_not_be_null():void
		{
			assertNotNull('Removed NativeSignal should not be null', signalSet.removed);
		}
		
		//////
		
		[Test]
		public function removedFromStage_signal_should_not_be_null():void
		{
			assertNotNull('RemovedFromStage NativeSignal should not be null', signalSet.removedFromStage);
		}
		
		//////
		
		[Test]
		public function render_signal_should_not_be_null():void
		{
			assertNotNull('Render NativeSignal should not be null', signalSet.render);
		}
		
		//////
		
		[Test]
		public function add_added_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.added.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.ADDED));
		}
		
		//////
		
		[Test]
		public function add_addedToStage_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.addedToStage.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
		}
		
		//////
		
		[Test]
		public function add_enterFrame_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.enterFrame.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.ENTER_FRAME));
		}
		
		//////
		
		[Test]
		public function add_exitFrame_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.exitFrame.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event("exitFrame"));
		}
		
		//////
		
		[Test]
		public function add_frameConstructed_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.frameConstructed.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event("frameConstructed"));
		}
		
		//////
		
		[Test]
		public function add_removed_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.removed.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.REMOVED));
		}
		
		//////
		
		[Test]
		public function add_removedFromStage_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.removedFromStage.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
		}
		
		//////
		
		[Test]
		public function add_render_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.render.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.RENDER));
		}
		
		//////
		
		[Test]
		public function add_added_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.added.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.ADDED));
		}
		
		//////
		
		[Test]
		public function add_addedToStage_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.addedToStage.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
		}
		
		//////
		
		[Test]
		public function add_enterFrame_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.enterFrame.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.ENTER_FRAME));
		}
		
		//////
		
		[Test]
		public function add_exitFrame_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.exitFrame.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event("exitFrame"));
		}
		
		//////
		
		[Test]
		public function add_frameConstructed_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.frameConstructed.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event("frameConstructed"));
		}
		
		//////
		
		[Test]
		public function add_removed_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.removed.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.REMOVED));
		}
		
		//////
		
		[Test]
		public function add_removedFromStage_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.removedFromStage.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
		}
		
		//////
		
		[Test]
		public function add_render_then_pause_and_dispatch_should_not_call_signal_listener():void
		{
			const slot:ISlot = signalSet.render.add(failIfCalled);
			slot.enabled = false;
			
			sprite.dispatchEvent(new Event(Event.RENDER));
		}
		
		//////
		
		[Test]
		public function add_added_then_numListeners_should_be_one():void
		{
			signalSet.added.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_addedToStage_then_numListeners_should_be_one():void
		{
			signalSet.addedToStage.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_enterFrame_then_numListeners_should_be_one():void
		{
			signalSet.enterFrame.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_exitFrame_then_numListeners_should_be_one():void
		{
			signalSet.exitFrame.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_frameConstructed_then_numListeners_should_be_one():void
		{
			signalSet.frameConstructed.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_removed_then_numListeners_should_be_one():void
		{
			signalSet.removed.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_removedFromStage_then_numListeners_should_be_one():void
		{
			signalSet.removedFromStage.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		//////
		
		[Test]
		public function add_render_then_numListeners_should_be_one():void
		{
			signalSet.render.add(handleEvent);
			assertTrue('Number of listeners should be 1', signalSet.numListeners == 1);
		}
		
		[Test]
		public function add_all_signals_then_numListeners_should_be_ten():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.added.add(handleEvent);
			signalSet.addedToStage.add(handleEvent);
			signalSet.enterFrame.add(handleEvent);
			signalSet.exitFrame.add(handleEvent);
			signalSet.frameConstructed.add(handleEvent);
			signalSet.removed.add(handleEvent);
			signalSet.removedFromStage.add(handleEvent);
			signalSet.render.add(handleEvent);
			assertTrue('Number of listeners should be 10', signalSet.numListeners == 10);
		}
		
		[Test]
		public function add_all_signals_then_remove_from_two_and_numListeners_should_be_eight():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.added.add(handleEvent);
			signalSet.addedToStage.add(handleEvent);
			signalSet.enterFrame.add(handleEvent);
			signalSet.exitFrame.add(handleEvent);
			signalSet.frameConstructed.add(handleEvent);
			signalSet.removed.add(handleEvent);
			signalSet.removedFromStage.add(handleEvent);
			signalSet.render.add(handleEvent);
			
			signalSet.addedToStage.removeAll();
			signalSet.exitFrame.removeAll();
			
			assertTrue('Number of listeners should be 8', signalSet.numListeners == 8);
		}
		
		[Test]
		public function add_all_signals_then_removeAll_and_numListeners_should_be_zero():void
		{
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.added.add(handleEvent);
			signalSet.addedToStage.add(handleEvent);
			signalSet.enterFrame.add(handleEvent);
			signalSet.exitFrame.add(handleEvent);
			signalSet.frameConstructed.add(handleEvent);
			signalSet.removed.add(handleEvent);
			signalSet.removedFromStage.add(handleEvent);
			signalSet.render.add(handleEvent);
			
			signalSet.removeAll();
			
			assertTrue('Number of listeners should be 0', signalSet.numListeners == 0);
		}
	}
}

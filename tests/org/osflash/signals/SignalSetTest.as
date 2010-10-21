package org.osflash.signals {
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertSame;
	import asunit.asserts.assertTrue;
	import asunit.framework.IAsync;

	import org.osflash.signals.natives.sets.EventDispatcherSignalSet;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;

	import flash.display.Sprite;
	import flash.events.Event;

	public class SignalSetTest {	

		[Inject]
	    public var async:IAsync;
	    
	    [Inject]
	    public var context:Sprite;
	
		private var sprite:Sprite;
		private var signalSet:InteractiveObjectSignalSet;

		[Before]
		public function setUp():void {
			sprite = new Sprite();
			signalSet = new InteractiveObjectSignalSet(sprite);
		}

		[After]
		public function tearDown():void {
			signalSet.removeAll();
			signalSet = null;
			sprite = null;
		}

		[Test]
		public function subclassed_signal_set_should_instiantate():void {
			assertTrue(signalSet is EventDispatcherSignalSet);
		}

		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(signalSet.numListeners, 0);
		}
		
		[Test]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			signalSet.activate.add(async.add(handleEvent));
			sprite.dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		[Test]
		public function stage_events_should_all_fire():void
		{
			signalSet.added.addOnce(async.add(handleEvent));			signalSet.addedToStage.addOnce(async.add(handleEvent));			
			signalSet.enterFrame.addOnce(async.add(handleEnterFrame));			signalSet.render.addOnce(async.add(handleRender));
						context.addChild(sprite);
		}

		private function handleEnterFrame(event:Event):void {
			sprite.stage.invalidate();
			
			assertSame(sprite, event.target);
		}

		private function handleRender(event:Event):void {
			assertSame(sprite, event.target);
		}
		
		[Test]
		public function should_fire_on_remove():void
		{
			signalSet.removed.addOnce(async.add(handleEvent));
			signalSet.removedFromStage.addOnce(async.add(handleEvent));
			
			context.addChild(sprite);			context.removeChild(sprite);
		}

		[Test]
		public function add_listeners_to_two_different_signals():void {
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			assertEquals(signalSet.numListeners, 2);
		}

		[Test]
		public function add_and_remove_signals():void {
			signalSet.activate.add(handleEvent);
			signalSet.deactivate.add(handleEvent);
			
			signalSet.removeAll();
			
			assertEquals(signalSet.numListeners, 0);
		}
		
		[Test]
		public function when_signal_adds_listener_then_target_should_have_listener():void
		{
			signalSet.activate.add(emptyHandler);
			assertEquals(1, signalSet.numListeners);
			assertTrue(sprite.hasEventListener(Event.ACTIVATE));
		}
		
		[Test]
		public function when_add_and_addOnce_should_have_one_listener():void
		{
			signalSet.activate.addOnce(emptyHandler);
			signalSet.deactivate.add(handleEvent);
			
			sprite.dispatchEvent(new Event(Event.ACTIVATE));
			
			assertEquals(1, signalSet.numListeners);
		}
		
		[Test]
		public function try_all_InteractiveObjectSignalSet_Events():void {
			signalSet.activate.add(handleEvent);			signalSet.added.add(handleEvent);			signalSet.addedToStage.add(handleEvent);			signalSet.click.add(handleEvent);			signalSet.deactivate.add(handleEvent);			signalSet.doubleClick.add(handleEvent);			signalSet.enterFrame.add(handleEvent);			signalSet.focusIn.add(handleEvent);			signalSet.focusOut.add(handleEvent);			signalSet.keyDown.add(handleEvent);			signalSet.keyFocusChange.add(handleEvent);			signalSet.keyUp.add(handleEvent);			signalSet.mouseDown.add(handleEvent);			signalSet.mouseFocusChange.add(handleEvent);			signalSet.mouseMove.add(handleEvent);			signalSet.mouseOut.add(handleEvent);			signalSet.mouseOver.add(handleEvent);			signalSet.mouseUp.add(handleEvent);			signalSet.mouseWheel.add(handleEvent);			signalSet.removed.add(handleEvent);			signalSet.render.add(handleEvent);			signalSet.rollOut.add(handleEvent);			signalSet.rollOver.add(handleEvent);			signalSet.tabChildrenChange.add(handleEvent);			signalSet.tabEnabledChange.add(handleEvent);			signalSet.tabIndexChange.add(handleEvent);
			
			assertSame(26, signalSet.numListeners);
		}

		private function handleEvent(event:Event):void
		{
			assertSame(sprite, event.target);
		}
		
		private function emptyHandler(e:Event):void {}
	}
}

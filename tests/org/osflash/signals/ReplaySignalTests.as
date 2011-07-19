package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertTrue;
	
	import flash.events.Event;

	public class ReplaySignalTests extends ISignalTestBase
	{
		[Before]
		public function setUp():void
		{
			signal = new ReplaySignal(false);
		}
		
		[Test]
		public function replays_history_when_replay_is_called_and_autoReplay_is_false():void
		{
			ReplaySignal(signal).autoReplay = false;
			
			const evt:Event = new Event("test");
			signal.dispatch(evt);
			signal.addOnce(function(event:Event):void{
				assertEquals("the event instances are the same", event, evt);
			});
			ReplaySignal(signal).replay();
		}
		
		[Test]
		public function replays_history_automatically():void
		{
			ReplaySignal(signal).autoReplay = true;
			
			const evt:Event = new Event("test");
			signal.dispatch(evt);
			var hasReplayed:Boolean = false;
			signal.addOnce(function(event:Event):void{
				hasReplayed = true;
				assertEquals("the event instances are the same", event, evt);
			});
			assertTrue("hasReplayed should be true", hasReplayed);
		}
		
		[Test]
		public function replays_history_but_does_not_remove_one_time_listeners():void
		{
			ReplaySignal(signal).autoReplay = false;
			
			const evt:Event = new Event("test");
			signal.dispatch(evt);
			
			var hasReplayed:Boolean = false;
			signal.addOnce(function(event:Event):void{
				hasReplayed = true;
				assertEquals("the event instances are the same", event, evt);
			});
			
			ReplaySignal(signal).replay();
			
			assertEquals("replay signal still has one listener", 1, signal.numListeners);
			
			signal.dispatch(evt);
			
			assertEquals("now replay signal has no listeners", 0, signal.numListeners);
		}
		
		[Test]
		public function replays_multiple_dispatches():void
		{
			ReplaySignal(signal).autoReplay = false;
			
			signal.dispatch();
			signal.dispatch();
			signal.dispatch();
			
			var numDispatches:int = 0;
			signal.add(function():void{
				++numDispatches;
			});
			
			ReplaySignal(signal).replay();
			
			assertEquals("replay signal replayed three dispatches", numDispatches, 3);
		}
		
		[Test]
		public function replays_multiple_dispatches_to_all_listeners():void
		{
			ReplaySignal(signal).autoReplay = false;
			
			signal.dispatch();
			signal.dispatch();
			signal.dispatch();
			
			var numDispatches:int = 0;
			signal.add(function():void{
				++numDispatches;
			});
			
			signal.add(function():void{
				++numDispatches;
			});
			
			ReplaySignal(signal).replay();
			
			assertEquals("replay signal replayed three dispatches", numDispatches, 6);
		}
		
		[Test]
		public function replays_multiple_dispatches_automatically():void
		{
			ReplaySignal(signal).autoReplay = true;
			
			signal.dispatch();
			signal.dispatch();
			signal.dispatch();
			
			var numDispatches:int = 0;
			signal.add(function():void{
				++numDispatches;
			});
			
			assertEquals("replay signal replayed three dispatches automatically", numDispatches, 3);
		}
	}
}
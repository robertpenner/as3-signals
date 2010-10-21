package org.osflash.signals {

	/**
	 * A convenient way to access a logical set of signals.
	 * 
	 * @author Jon Adams
	 * 
	 * @example SignalSets allow you to get predefined signals for many built in events
	 * <listing version="3.0" >
		package {
			import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
		
			import flash.display.Sprite;
			import flash.events.Event;
		
			public class Example extends Sprite {
		
				private var button:Sprite;
				private var buttonSignals:InteractiveObjectSignalSet;
		
				public function Main() {
					button = new Sprite();
					button.graphics.beginFill(0xff0000);
					button.graphics.drawRect(0, 0, 100, 100);
					button.graphics.endFill();
					
					buttonSignals = new InteractiveObjectSignalSet(button);
					buttonSignals.click.add(handler);
					buttonSignals.addedToStage.add(handler);
					buttonSignals.enterFrame.addOnce(handler);
					
					addChild(button);
				}
		
				private function handler(event:Event):void {
					trace(event.target, "fired", event.type);
				}
			}
		}
	 * </listing>
	 */
	public class SignalSet {

		protected var _signals:Array = [];

		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void {
			while(_signals.length) {
				var iSignalOwner:ISignalOwner = _signals.pop();
				iSignalOwner.removeAll();
			}
		}

		/**
		 * The current number of listeners for the signal.
		 */
		public function get numListeners():int {
			var count:int = 0;
			for each (var iSignalOwner : ISignalOwner in _signals) {
				count += iSignalOwner.numListeners;
			}
			return count;
		}
		
		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array {
			return _signals.concat();
		}
	}
}
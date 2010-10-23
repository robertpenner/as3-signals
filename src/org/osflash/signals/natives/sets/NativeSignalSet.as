package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.natives.INativeSignalOwner;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

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
	public class NativeSignalSet 
	{
		protected var target:IEventDispatcher;
		protected var _signals:Array = [];

		public function NativeSignalSet(target:IEventDispatcher) 
		{
			this.target = target;
		}

		/**
		 * Lazily instantiats a NativeSignal
		 */
		protected function getNativeSignal(eventType:String, eventClass:Class = null):NativeSignal 
		{
			eventClass = eventClass || Event;
			
			var i:int = _signals.length; 
			while(i--) 
			{
				var signal:NativeSignal = _signals[i] as NativeSignal;
				if(signal.target == target && signal.eventType == eventType && signal.eventClass == eventClass) 
				{
					return signal;
				}
			}
			
			var nativeSignal:NativeSignal = new NativeSignal(target, eventType, eventClass);
			addSignal(nativeSignal);
			
			return nativeSignal;
		}

		/**
		 * adds a INativeSignalOwner to the list of instantiated signals
		 */
		protected function addSignal(iNativeSignalOwner :INativeSignalOwner ):void {
			_signals.push(iNativeSignalOwner );
		}

		/**
		 * The current number of listeners for the signal.
		 */
		public function get numListeners():uint {
			var count:uint = 0;
			for each (var iNativeSignalOwner : INativeSignalOwner in _signals) {
				count += iNativeSignalOwner.numListeners;
			}
			return count;
		}
		
		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array {
			return _signals.concat();
		}
		
		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void {
			while(_signals.length) {
				var iNativeSignalOwner:INativeSignalOwner = _signals.pop();
				iNativeSignalOwner.removeAll();
			}
		}
	}
}

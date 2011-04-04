package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.natives.INativeDispatcher;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

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
		
		protected const _signals:Dictionary = new Dictionary();

		public function NativeSignalSet(target:IEventDispatcher) 
		{
			this.target = target;
		}

		/**
		 * Lazily instantiates a NativeSignal
		 */
		public function getNativeSignal(eventType:String, eventClass:Class = null):NativeSignal 
		{
			if(null == eventType) throw new ArgumentError('eventType must not be null.');
			
			return _signals[eventType] ||= new NativeSignal(target, eventType, eventClass || Event);
		}

		/**
		 * The current number of listeners for the signal.
		 */
		public function get numListeners():int 
		{
			var count:int = 0;
			for each (var signal:INativeDispatcher in _signals) 
			{
				count += signal.numListeners;
			}
			return count;
		}
		
		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array 
		{
			var result:Array = [];
			for each (var signal:INativeDispatcher in _signals) 
			{
				result[result.length] = signal;
			}
			return result;
		}
		
		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void 
		{
			for each (var signal:INativeDispatcher in _signals) 
			{
				signal.removeAll();
				delete _signals[signal.eventType];
			}
		}
	}
}

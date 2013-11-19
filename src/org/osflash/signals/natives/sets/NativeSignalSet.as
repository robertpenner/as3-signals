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
		
		protected const _signals:Object = {};

		public function NativeSignalSet(target:IEventDispatcher) 
		{
			this.target = target;
		}

		/**
		 * Lazily instantiates a NativeSignal
		 * @throws ArgumentError <code>ArgumentError</code>: eventType must not be null.
		 */
		public function getNativeSignal(eventType:String, eventClass:Class = null):NativeSignal 
		{
			if(null == eventType) throw new ArgumentError('eventType must not be null.');
			
			return _signals[eventType] ||= new NativeSignal(target, eventType, eventClass || Event);
		}

		/**
		 * The current number of listeners for the signal.
		 */
		public function get numListeners():uint 
		{
			var count:uint;
			for (var p:String in _signals)
			{
				count += _signals[p].numListeners;
			}
			return count;
		}
		
		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array 
		{
			var result:Array = [];
			var i:uint;
			for (var p:String in _signals)
			{
				result[i++] = _signals[p];
			}
			return result;
		}
		
		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void 
		{
			for (var p:String in _signals)
			{
				_signals[p].removeAll();
				delete _signals[p];
			}
		}
	}
}

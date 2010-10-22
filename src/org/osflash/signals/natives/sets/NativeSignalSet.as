package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.natives.INativeSignalOwner;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author Jon Adams
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
		public function get numListeners():int {
			var count:int = 0;
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

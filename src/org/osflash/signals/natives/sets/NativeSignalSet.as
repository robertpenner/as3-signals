package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.SignalSet;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author Jon Adams
	 */
	public class NativeSignalSet extends SignalSet 
	{
		protected var target:IEventDispatcher;

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
	}
}

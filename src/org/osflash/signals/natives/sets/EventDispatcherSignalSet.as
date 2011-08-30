package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Jon Adams
	 */
	public class EventDispatcherSignalSet extends NativeSignalSet 
	{
		public function EventDispatcherSignalSet(target:EventDispatcher) 
		{
			super(target);
		}

		public function get activate():NativeSignal 
		{
			return getNativeSignal(Event.ACTIVATE);
		}

		public function get deactivate():NativeSignal 
		{	
			return getNativeSignal(Event.DEACTIVATE);
		}
	}
}

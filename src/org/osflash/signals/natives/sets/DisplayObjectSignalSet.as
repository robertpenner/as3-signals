package org.osflash.signals.natives.sets 
{
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class DisplayObjectSignalSet extends EventDispatcherSignalSet 
	{
		
		public function DisplayObjectSignalSet(target:DisplayObject) 
		{
			super(target);
		}

		public function get added():NativeSignal 
		{
			return getNativeSignal(Event.ADDED);
		}
		public function get addedToStage():NativeSignal 
		{
			return getNativeSignal(Event.ADDED_TO_STAGE);
		}
		public function get enterFrame():NativeSignal 
		{
			return getNativeSignal(Event.ENTER_FRAME);
		}
		public function get exitFrame():NativeSignal 
		{
			// Using a string here because we need to target FP9
			return getNativeSignal("exitFrame");
		}
		
		public function get frameConstructed():NativeSignal 
		{
			// Using a string here because we need to target FP9
			return getNativeSignal("frameConstructed");
		}

		public function get removed():NativeSignal 
		{
			return getNativeSignal(Event.REMOVED);
		}
		public function get removedFromStage():NativeSignal 
		{
			return getNativeSignal(Event.REMOVED_FROM_STAGE);
		}
		public function get render():NativeSignal 
		{
			return getNativeSignal(Event.RENDER);
		}
	}
}

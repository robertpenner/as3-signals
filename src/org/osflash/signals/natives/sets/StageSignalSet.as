package org.osflash.signals.natives.sets
{
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class StageSignalSet extends InteractiveObjectSignalSet
	{

		public function StageSignalSet(target : Stage)
		{
			super(target);
		}

		public function get fullScreen() : NativeSignal
		{
			return getNativeSignal(Event.FULLSCREEN);
		}

		public function get mouseLeave() : NativeSignal
		{
			return getNativeSignal(Event.MOUSE_LEAVE);
		}

		public function get resize() : NativeSignal
		{
			return getNativeSignal(Event.RESIZE);
		}
	}
}

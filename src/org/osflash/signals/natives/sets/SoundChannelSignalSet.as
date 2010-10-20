package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class SoundChannelSignalSet extends EventDispatcherSignalSet {

		public var soundComplete:NativeSignal;

		public function SoundChannelSignalSet(target:DisplayObject) {
			super(target);
			signals.push(soundComplete = new NativeSignal(target, Event.SOUND_COMPLETE, Event));
		}
	}
}

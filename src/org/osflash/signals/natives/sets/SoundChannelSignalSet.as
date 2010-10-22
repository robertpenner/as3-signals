package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.media.SoundChannel;

	/**
	 * @author Jon Adams
	 */
	public class SoundChannelSignalSet extends EventDispatcherSignalSet {

		public function SoundChannelSignalSet(target:SoundChannel) {
			super(target);
		}

		public function get soundComplete():NativeSignal {
			return getNativeSignal(Event.SOUND_COMPLETE);
		}
	}
}

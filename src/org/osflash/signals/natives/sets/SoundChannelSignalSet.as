package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.media.SoundChannel;

	/**
	 * @author Jon Adams
	 */
	public class SoundChannelSignalSet extends EventDispatcherSignalSet {

		public var soundComplete:NativeSignal;

		public function SoundChannelSignalSet(target:SoundChannel) {
			super(target);
			_signals.push(soundComplete = new NativeSignal(target, Event.SOUND_COMPLETE, Event));
		}
	}
}

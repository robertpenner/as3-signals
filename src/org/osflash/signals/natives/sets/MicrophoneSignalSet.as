package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;

	/**
	 * @author Jon Adams
	 */
	public class MicrophoneSignalSet extends EventDispatcherSignalSet {

		public function MicrophoneSignalSet(target:Microphone) {
			super(target);
		}

		public function get activity():NativeSignal {
			return getNativeSignal(ActivityEvent.ACTIVITY, ActivityEvent);
		}
		public function get status():NativeSignal {
			return getNativeSignal(StatusEvent.STATUS, StatusEvent);
		}
	}
}

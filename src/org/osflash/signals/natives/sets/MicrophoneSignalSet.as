package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;

	/**
	 * @author Jon Adams
	 */
	public class MicrophoneSignalSet extends EventDispatcherSignalSet {

		private var activity:NativeSignal;
		private var status:NativeSignal;

		public function MicrophoneSignalSet(target:Microphone) {
			super(target);
			_signals.push(activity = new NativeSignal(target, ActivityEvent.ACTIVITY, ActivityEvent));			_signals.push(status = new NativeSignal(target, StatusEvent.STATUS, StatusEvent));
		}
	}
}

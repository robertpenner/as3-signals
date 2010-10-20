package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;

	/**
	 * @author Jon Adams
	 */
	public class MicrophoneSignalSet extends EventDispatcherSignalSet {

		private var activity:NativeSignal;
		private var status:NativeSignal;

		public function MicrophoneSignalSet(target:DisplayObject) {
			super(target);
			signals.push(activity = new NativeSignal(target, ActivityEvent.ACTIVITY, ActivityEvent));			signals.push(status = new NativeSignal(target, StatusEvent.STATUS, StatusEvent));
		}
	}
}

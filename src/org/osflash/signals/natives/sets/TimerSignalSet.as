package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.TimerEvent;

	/**
	 * @author Jon Adams
	 */
	public class TimerSignalSet extends EventDispatcherSignalSet {

		public var timer:NativeSignal;
		public var timerComplete:NativeSignal;

		public function TimerSignalSet(target:DisplayObject) {
			super(target);
			signals.push(timer = new NativeSignal(target, TimerEvent.TIMER, TimerEvent));			signals.push(timerComplete = new NativeSignal(target, TimerEvent.TIMER_COMPLETE, TimerEvent));
		}
	}
}

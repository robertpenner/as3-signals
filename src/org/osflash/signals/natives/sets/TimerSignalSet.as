package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Jon Adams
	 */
	public class TimerSignalSet extends EventDispatcherSignalSet {

		public var timer:NativeSignal;
		public var timerComplete:NativeSignal;

		public function TimerSignalSet(target:Timer) {
			super(target);
			_signals.push(timer = new NativeSignal(target, TimerEvent.TIMER, TimerEvent));			_signals.push(timerComplete = new NativeSignal(target, TimerEvent.TIMER_COMPLETE, TimerEvent));
		}
	}
}

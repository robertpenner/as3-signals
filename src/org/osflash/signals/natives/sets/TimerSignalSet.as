package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Jon Adams
	 */
	public class TimerSignalSet extends EventDispatcherSignalSet {

		public function TimerSignalSet(target:Timer) {
			super(target);
		}

		public function get timer():NativeSignal {
			return getNativeSignal(TimerEvent.TIMER, TimerEvent);
		}
		public function get timerComplete():NativeSignal {
			return getNativeSignal(TimerEvent.TIMER_COMPLETE, TimerEvent);
		}
	}
}

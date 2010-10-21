package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class StageSignalSet extends InteractiveObjectSignalSet {

		public var fullScreen:NativeSignal;
		public var mouseLeave:NativeSignal;
		public var resize:NativeSignal;

		public function StageSignalSet(target:Stage) {
			super(target);
			_signals.push(fullScreen = new NativeSignal(target, Event.FULLSCREEN, Event));			_signals.push(mouseLeave = new NativeSignal(target, Event.MOUSE_LEAVE, Event));			_signals.push(resize = new NativeSignal(target, Event.RESIZE, Event));
		}
	}
}

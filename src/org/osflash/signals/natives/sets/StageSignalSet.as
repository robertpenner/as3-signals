package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class StageSignalSet extends InteractiveObjectSignalSet {

		public var fullScreen:NativeSignal;
		public var mouseLeave:NativeSignal;
		public var resize:NativeSignal;

		public function StageSignalSet(target:DisplayObject) {
			super(target);
			signals.push(fullScreen = new NativeSignal(target, Event.FULLSCREEN, Event));			signals.push(mouseLeave = new NativeSignal(target, Event.MOUSE_LEAVE, Event));			signals.push(resize = new NativeSignal(target, Event.RESIZE, Event));
		}
	}
}

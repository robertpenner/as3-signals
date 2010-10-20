package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class FileReferenceListSignalSet extends EventDispatcherSignalSet {

		public var cancel:NativeSignal;
		public var select:NativeSignal;

		public function FileReferenceListSignalSet(target:DisplayObject) {
			super(target);
			signals.push(cancel = new NativeSignal(target, Event.CANCEL, Event));
			signals.push(select = new NativeSignal(target, Event.SELECT, Event));
		}
	}
}

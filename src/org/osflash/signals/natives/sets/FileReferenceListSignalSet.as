package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.net.FileReference;

	/**
	 * @author Jon Adams
	 */
	public class FileReferenceListSignalSet extends EventDispatcherSignalSet {

		public var cancel:NativeSignal;
		public var select:NativeSignal;

		public function FileReferenceListSignalSet(target:FileReference) {
			super(target);
			_signals.push(cancel = new NativeSignal(target, Event.CANCEL, Event));
			_signals.push(select = new NativeSignal(target, Event.SELECT, Event));
		}
	}
}

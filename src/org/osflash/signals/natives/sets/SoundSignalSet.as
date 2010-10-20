package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	/**
	 * @author Jon Adams
	 */
	public class SoundSignalSet extends EventDispatcherSignalSet {

		public var complete:NativeSignal;
		public var id3:NativeSignal;
		public var ioError:NativeSignal;
		public var open:NativeSignal;
		public var progress:NativeSignal;
		
		public function SoundSignalSet(target:DisplayObject) {
			super(target);
			signals.push(complete = new NativeSignal(target, Event.COMPLETE, Event));
			signals.push(id3 = new NativeSignal(target, Event.ID3, Event));
			signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			signals.push(open = new NativeSignal(target, Event.OPEN, Event));
			signals.push(progress = new NativeSignal(target, ProgressEvent.PROGRESS, ProgressEvent));
		}
	}
}

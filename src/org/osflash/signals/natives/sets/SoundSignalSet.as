package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;

	/**
	 * @author Jon Adams
	 */
	public class SoundSignalSet extends EventDispatcherSignalSet {

		public var complete:NativeSignal;
		public var id3:NativeSignal;
		public var ioError:NativeSignal;
		public var open:NativeSignal;
		public var progress:NativeSignal;
		
		public function SoundSignalSet(target:Sound) {
			super(target);
			_signals.push(complete = new NativeSignal(target, Event.COMPLETE, Event));
			_signals.push(id3 = new NativeSignal(target, Event.ID3, Event));
			_signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			_signals.push(open = new NativeSignal(target, Event.OPEN, Event));
			_signals.push(progress = new NativeSignal(target, ProgressEvent.PROGRESS, ProgressEvent));
		}
	}
}

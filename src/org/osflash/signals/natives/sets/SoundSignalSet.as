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

		public function SoundSignalSet(target:Sound) {
			super(target);
		}

		public function get complete():NativeSignal {
			return getNativeSignal(Event.COMPLETE);
		}

		public function get id3():NativeSignal {
			return getNativeSignal(Event.ID3);
		}

		public function get ioError():NativeSignal {
			return getNativeSignal(IOErrorEvent.IO_ERROR, IOErrorEvent);
		}

		public function get open():NativeSignal {
			return getNativeSignal(Event.OPEN);
		}

		public function get progress():NativeSignal {
			return getNativeSignal(ProgressEvent.PROGRESS, ProgressEvent);
		}
	}
}

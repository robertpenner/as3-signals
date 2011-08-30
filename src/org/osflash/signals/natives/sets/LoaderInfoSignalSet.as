package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	/**
	 * @author Jon Adams
	 */
	public class LoaderInfoSignalSet extends EventDispatcherSignalSet {

		public function LoaderInfoSignalSet(target:LoaderInfo) {
			super(target);
		}

		public function get complete():NativeSignal {
			return getNativeSignal(Event.COMPLETE);
		}

		public function get httpStatus():NativeSignal {
			return getNativeSignal(HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent);
		}

		public function get init():NativeSignal {
			return getNativeSignal(Event.INIT);
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

		public function get unload():NativeSignal {
			return getNativeSignal(Event.UNLOAD);
		}
	}
}

package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;

	/**
	 * @author Jon Adams
	 */
	public class FileReferenceSignalSet extends EventDispatcherSignalSet {

		public function FileReferenceSignalSet(target:FileReference) {
			super(target);
		}

		public function get cancel():NativeSignal {
			return getNativeSignal(Event.CANCEL);
		}
		public function get complete():NativeSignal {
			return getNativeSignal(Event.COMPLETE);
		}

		public function get httpStatus():NativeSignal {
			return getNativeSignal(HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent);
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

		public function get securityError():NativeSignal {
			return getNativeSignal(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
		}
		public function get select():NativeSignal {
			return getNativeSignal(Event.SELECT);
		}
		public function get uploadCompleteData():NativeSignal {
			return getNativeSignal(DataEvent.UPLOAD_COMPLETE_DATA, DataEvent);
		}
	}
}

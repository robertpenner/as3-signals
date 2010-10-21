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

		public var cancel:NativeSignal;
		public var complete:NativeSignal;
		public var httpStatus:NativeSignal;
		public var ioError:NativeSignal;
		public var open:NativeSignal;
		public var progress:NativeSignal;
		public var securityError:NativeSignal;
		public var select:NativeSignal;
		public var uploadCompleteData:NativeSignal;

		public function FileReferenceSignalSet(target:FileReference) {
			super(target);
			_signals.push(cancel = new NativeSignal(target, Event.CANCEL, Event));			_signals.push(complete = new NativeSignal(target, Event.COMPLETE, Event));
			_signals.push(httpStatus = new NativeSignal(target, HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent));
			_signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			_signals.push(open = new NativeSignal(target, Event.OPEN, Event));
			_signals.push(progress = new NativeSignal(target, ProgressEvent.PROGRESS, ProgressEvent));
			_signals.push(securityError = new NativeSignal(target, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent));			_signals.push(select = new NativeSignal(target, Event.SELECT, Event));			_signals.push(uploadCompleteData = new NativeSignal(target, DataEvent.UPLOAD_COMPLETE_DATA, DataEvent));
		}
	}
}

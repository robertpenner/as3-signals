package org.osflash.signals.natives.sets {
	import flash.events.DataEvent;

	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

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

		public function FileReferenceSignalSet(target:DisplayObject) {
			super(target);
			signals.push(cancel = new NativeSignal(target, Event.CANCEL, Event));			signals.push(complete = new NativeSignal(target, Event.COMPLETE, Event));
			signals.push(httpStatus = new NativeSignal(target, HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent));
			signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			signals.push(open = new NativeSignal(target, Event.OPEN, Event));
			signals.push(progress = new NativeSignal(target, ProgressEvent.PROGRESS, ProgressEvent));
			signals.push(securityError = new NativeSignal(target, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent));			signals.push(select = new NativeSignal(target, Event.SELECT, Event));			signals.push(uploadCompleteData = new NativeSignal(target, DataEvent.UPLOAD_COMPLETE_DATA, DataEvent));
		}
	}
}

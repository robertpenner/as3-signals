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

		public var complete:NativeSignal;
		public var httpStatus:NativeSignal;		public var init:NativeSignal;
		public var ioError:NativeSignal;
		public var open:NativeSignal;
		public var progress:NativeSignal;
		public var unload:NativeSignal;

		public function LoaderInfoSignalSet(target:LoaderInfo) {
			super(target);
			_signals.push(complete = new NativeSignal(target, Event.COMPLETE, Event));
			_signals.push(httpStatus = new NativeSignal(target, HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent));
			_signals.push(init = new NativeSignal(target, Event.INIT, Event));			_signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			_signals.push(open = new NativeSignal(target, Event.OPEN, Event));
			_signals.push(progress = new NativeSignal(target, ProgressEvent.PROGRESS, ProgressEvent));
			_signals.push(unload = new NativeSignal(target, Event.UNLOAD, Event));
		}
	}
}

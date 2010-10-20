package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * @author Jon Adams
	 */
	public class SocketSignalSet extends EventDispatcherSignalSet {

		public var close:NativeSignal;
		public var connect:NativeSignal;
		public var ioError:NativeSignal;
		public var securityError:NativeSignal;
		public var open:NativeSignal;
		public var socketData:NativeSignal;

		public function SocketSignalSet(target:DisplayObject) {
			super(target);
			signals.push(close = new NativeSignal(target, Event.CLOSE, Event));
			signals.push(connect = new NativeSignal(target, Event.CONNECT, Event));
			signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			signals.push(securityError = new NativeSignal(target, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent));
			signals.push(socketData = new NativeSignal(target, ProgressEvent.SOCKET_DATA, ProgressEvent));
		}
	}
}

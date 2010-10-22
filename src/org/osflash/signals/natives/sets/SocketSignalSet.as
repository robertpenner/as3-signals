package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	/**
	 * @author Jon Adams
	 */
	public class SocketSignalSet extends EventDispatcherSignalSet {

		public function SocketSignalSet(target:Socket) {
			super(target);
		}

		public function get close():NativeSignal {
			return getNativeSignal(Event.CLOSE);
		}

		public function get connect():NativeSignal {
			return getNativeSignal(Event.CONNECT);
		}

		public function get ioError():NativeSignal {
			return getNativeSignal(IOErrorEvent.IO_ERROR, IOErrorEvent);
		}

		public function get securityError():NativeSignal {
			return getNativeSignal(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
		}

		public function get socketData():NativeSignal {
			return getNativeSignal(ProgressEvent.SOCKET_DATA, ProgressEvent);
		}
	}
}

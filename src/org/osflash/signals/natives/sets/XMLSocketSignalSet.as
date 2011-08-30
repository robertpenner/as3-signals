package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	/**
	 * @author Jon Adams
	 */
	public class XMLSocketSignalSet extends EventDispatcherSignalSet {

		public function XMLSocketSignalSet(target:XMLSocket) {
			super(target);
		}

		public function get close():NativeSignal {
			return getNativeSignal(Event.CLOSE);
		}
		public function get connect():NativeSignal {
			return getNativeSignal(Event.CONNECT);
		}
		public function get data():NativeSignal {
			return getNativeSignal(DataEvent.DATA, DataEvent);
		}
		public function get ioError():NativeSignal {
			return getNativeSignal(IOErrorEvent.IO_ERROR, IOErrorEvent);
		}
		public function get securityError():NativeSignal {
			return getNativeSignal(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
		}
	}
}

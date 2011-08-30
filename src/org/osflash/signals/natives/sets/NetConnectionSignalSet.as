package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	/**
	 * @author Jon Adams
	 */
	public class NetConnectionSignalSet extends EventDispatcherSignalSet {

		public function NetConnectionSignalSet(target:NetConnection) {
			super(target);
		}

		public function get asyncError():NativeSignal {
			return getNativeSignal(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorEvent);
		}

		public function get ioError():NativeSignal {
			return getNativeSignal(IOErrorEvent.IO_ERROR, IOErrorEvent);
		}

		public function get netStatus():NativeSignal {
			return getNativeSignal(NetStatusEvent.NET_STATUS, NetStatusEvent);
		}

		public function get securityError():NativeSignal {
			return getNativeSignal(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
		}
	}
}

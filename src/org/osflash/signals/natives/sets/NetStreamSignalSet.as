package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	/**
	 * @author Jon Adams
	 */
	public class NetStreamSignalSet extends EventDispatcherSignalSet {

		public function NetStreamSignalSet(target:NetStream) {
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
	}
}

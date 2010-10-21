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

		public var asyncError:NativeSignal;
		public var ioError:NativeSignal;
		public var netStatus:NativeSignal;
		public var securityError:NativeSignal;

		public function NetConnectionSignalSet(target:NetConnection) {
			super(target);
			_signals.push(asyncError = new NativeSignal(target, AsyncErrorEvent.ASYNC_ERROR, AsyncErrorEvent));
			_signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			_signals.push(netStatus = new NativeSignal(target, NetStatusEvent.NET_STATUS, NetStatusEvent));
			_signals.push(securityError = new NativeSignal(target, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent));
		}
	}
}

package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * @author Jon Adams
	 */
	public class NetConnectionSignalSet extends EventDispatcherSignalSet {

		public var asyncError:NativeSignal;
		public var ioError:NativeSignal;
		public var netStatus:NativeSignal;
		public var securityError:NativeSignal;

		public function NetConnectionSignalSet(target:DisplayObject) {
			super(target);
			signals.push(asyncError = new NativeSignal(target, AsyncErrorEvent.ASYNC_ERROR, AsyncErrorEvent));
			signals.push(ioError = new NativeSignal(target, IOErrorEvent.IO_ERROR, IOErrorEvent));
			signals.push(netStatus = new NativeSignal(target, NetStatusEvent.NET_STATUS, NetStatusEvent));
			signals.push(securityError = new NativeSignal(target, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent));
		}
	}
}

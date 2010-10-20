package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;

	/**
	 * @author Jon Adams
	 */
	public class SharedObjectSignalSet extends EventDispatcherSignalSet {

		public var asyncError:NativeSignal;
		public var netStatus:NativeSignal;
		public var sync:NativeSignal;

		public function SharedObjectSignalSet(target:DisplayObject) {
			super(target);
			signals.push(asyncError = new NativeSignal(target, AsyncErrorEvent.ASYNC_ERROR, AsyncErrorEvent));			signals.push(netStatus = new NativeSignal(target, NetStatusEvent.NET_STATUS, NetStatusEvent));			signals.push(sync = new NativeSignal(target, SyncEvent.SYNC, SyncEvent));
		}
	}
}

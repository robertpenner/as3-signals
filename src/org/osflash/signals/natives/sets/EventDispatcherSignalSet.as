package org.osflash.signals.natives.sets {
	import org.osflash.signals.SignalSet;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author Jon Adams
	 */
	public class EventDispatcherSignalSet extends SignalSet {

		public var activate:NativeSignal;
		public var deactivate:NativeSignal;

		public function EventDispatcherSignalSet(target:IEventDispatcher) {
			_signals.push(activate = new NativeSignal(target, Event.ACTIVATE, Event));			_signals.push(deactivate = new NativeSignal(target, Event.DEACTIVATE, Event));
		}
	}
}

package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jon Adams
	 */
	public class DisplayObjectSignalSet extends EventDispatcherSignalSet {

		public var added:NativeSignal;
		public var addedToStage:NativeSignal;
		public var enterFrame:NativeSignal;
		public var removed:NativeSignal;
		public var removedFromStage:NativeSignal;
		public var render:NativeSignal;
		
		public function DisplayObjectSignalSet(target:DisplayObject) {
			super(target);
			_signals.push(added = new NativeSignal(target, Event.ADDED, Event));			_signals.push(addedToStage = new NativeSignal(target, Event.ADDED_TO_STAGE, Event));			_signals.push(enterFrame = new NativeSignal(target, Event.ENTER_FRAME, Event));			_signals.push(removed = new NativeSignal(target, Event.REMOVED, Event));			_signals.push(removedFromStage = new NativeSignal(target, Event.REMOVED_FROM_STAGE, Event));			_signals.push(render = new NativeSignal(target, Event.RENDER, Event));
		}
	}
}

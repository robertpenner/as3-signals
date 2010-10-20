package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;

	/**
	 * @author Jon Adams
	 */
	public class TextFieldSignalSet extends InteractiveObjectSignalSet {

		public var change:NativeSignal;
		public var link:NativeSignal;
		public var scroll:NativeSignal;
		public var textInput:NativeSignal;

		public function TextFieldSignalSet(target:DisplayObject) {
			super(target);
			signals.push(change = new NativeSignal(target, Event.CHANGE, Event));			signals.push(link = new NativeSignal(target, TextEvent.LINK, TextEvent));			signals.push(scroll = new NativeSignal(target, Event.SCROLL, Event));			signals.push(textInput = new NativeSignal(target, TextEvent.TEXT_INPUT, TextEvent));
		}
	}
}

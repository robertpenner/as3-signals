package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * @author Jon Adams
	 */
	public class TextFieldSignalSet extends InteractiveObjectSignalSet {

		public var change:NativeSignal;
		public var link:NativeSignal;
		public var scroll:NativeSignal;
		public var textInput:NativeSignal;

		public function TextFieldSignalSet(target:TextField) {
			super(target);
			_signals.push(change = new NativeSignal(target, Event.CHANGE, Event));			_signals.push(link = new NativeSignal(target, TextEvent.LINK, TextEvent));			_signals.push(textInput = new NativeSignal(target, TextEvent.TEXT_INPUT, TextEvent));
		}
	}
}

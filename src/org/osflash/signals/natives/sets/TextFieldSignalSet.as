package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * @author Jon Adams
	 */
	public class TextFieldSignalSet extends InteractiveObjectSignalSet {

		public function TextFieldSignalSet(target:TextField) {
			super(target);
		}

		public function get change():NativeSignal {
			return getNativeSignal(Event.CHANGE);
		}
		public function get link():NativeSignal {
			return getNativeSignal(TextEvent.LINK, TextEvent);
		}
	}
}

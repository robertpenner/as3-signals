package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	/**
	 * @author Jon Adams
	 */
	public class InteractiveObjectSignalSet extends DisplayObjectSignalSet {

		public var click:NativeSignal;
		public var doubleClick:NativeSignal;
		public var focusIn:NativeSignal;
		public var focusOut:NativeSignal;
		public var keyDown:NativeSignal;
		public var keyFocusChange:NativeSignal;
		public var keyUp:NativeSignal;
		public var mouseDown:NativeSignal;
		public var mouseFocusChange:NativeSignal;
		public var mouseMove:NativeSignal;
		public var mouseOut:NativeSignal;
		public var mouseOver:NativeSignal;
		public var mouseUp:NativeSignal;
		public var mouseWheel:NativeSignal;
		public var rollOut:NativeSignal;
		public var rollOver:NativeSignal;
		public var tabChildrenChange:NativeSignal;
		public var tabEnabledChange:NativeSignal;
		public var tabIndexChange:NativeSignal;
		public var textInput:NativeSignal;

		public function InteractiveObjectSignalSet(target:DisplayObject) {
			super(target);
			signals.push(click = new NativeSignal(target, MouseEvent.CLICK, MouseEvent));
			signals.push(doubleClick = new NativeSignal(target, MouseEvent.DOUBLE_CLICK, MouseEvent));
			signals.push(focusIn = new NativeSignal(target, FocusEvent.FOCUS_IN, FocusEvent));
			signals.push(focusOut = new NativeSignal(target, FocusEvent.FOCUS_OUT, FocusEvent));
			signals.push(keyDown = new NativeSignal(target, KeyboardEvent.KEY_DOWN, KeyboardEvent));
			signals.push(keyFocusChange = new NativeSignal(target, FocusEvent.KEY_FOCUS_CHANGE, FocusEvent));
			signals.push(keyUp = new NativeSignal(target, KeyboardEvent.KEY_DOWN, KeyboardEvent));
			signals.push(mouseDown = new NativeSignal(target, MouseEvent.MOUSE_DOWN, MouseEvent));
			signals.push(mouseFocusChange = new NativeSignal(target, FocusEvent.MOUSE_FOCUS_CHANGE, FocusEvent));
			signals.push(mouseMove = new NativeSignal(target, MouseEvent.MOUSE_MOVE, MouseEvent));
			signals.push(mouseOut = new NativeSignal(target, MouseEvent.MOUSE_OUT, MouseEvent));
			signals.push(mouseOver = new NativeSignal(target, MouseEvent.MOUSE_OVER, MouseEvent));
			signals.push(mouseUp = new NativeSignal(target, MouseEvent.MOUSE_UP, MouseEvent));
			signals.push(mouseWheel = new NativeSignal(target, MouseEvent.MOUSE_WHEEL, MouseEvent));
			signals.push(rollOut = new NativeSignal(target, MouseEvent.ROLL_OUT, MouseEvent));
			signals.push(rollOver = new NativeSignal(target, MouseEvent.ROLL_OVER, MouseEvent));
			signals.push(tabChildrenChange = new NativeSignal(target, Event.TAB_CHILDREN_CHANGE, Event));
			signals.push(tabEnabledChange = new NativeSignal(target, Event.TAB_ENABLED_CHANGE, Event));
			signals.push(tabIndexChange = new NativeSignal(target, Event.TAB_INDEX_CHANGE, Event));
			signals.push(textInput = new NativeSignal(target, TextEvent.TEXT_INPUT, TextEvent));

		}
	}
}

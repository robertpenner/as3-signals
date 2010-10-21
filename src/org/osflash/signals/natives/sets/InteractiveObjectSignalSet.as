package org.osflash.signals.natives.sets {
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.InteractiveObject;
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
		public var tabChildrenChange:NativeSignal;		public var tabEnabledChange:NativeSignal;
		public var tabIndexChange:NativeSignal;
		public var textInput:NativeSignal;

		public function InteractiveObjectSignalSet(target:InteractiveObject) {
			super(target);
			_signals.push(click = new NativeSignal(target, MouseEvent.CLICK, MouseEvent));
			_signals.push(doubleClick = new NativeSignal(target, MouseEvent.DOUBLE_CLICK, MouseEvent));
			_signals.push(focusIn = new NativeSignal(target, FocusEvent.FOCUS_IN, FocusEvent));
			_signals.push(focusOut = new NativeSignal(target, FocusEvent.FOCUS_OUT, FocusEvent));
			_signals.push(keyDown = new NativeSignal(target, KeyboardEvent.KEY_DOWN, KeyboardEvent));
			_signals.push(keyFocusChange = new NativeSignal(target, FocusEvent.KEY_FOCUS_CHANGE, FocusEvent));
			_signals.push(keyUp = new NativeSignal(target, KeyboardEvent.KEY_DOWN, KeyboardEvent));
			_signals.push(mouseDown = new NativeSignal(target, MouseEvent.MOUSE_DOWN, MouseEvent));
			_signals.push(mouseFocusChange = new NativeSignal(target, FocusEvent.MOUSE_FOCUS_CHANGE, FocusEvent));
			_signals.push(mouseMove = new NativeSignal(target, MouseEvent.MOUSE_MOVE, MouseEvent));
			_signals.push(mouseOut = new NativeSignal(target, MouseEvent.MOUSE_OUT, MouseEvent));
			_signals.push(mouseOver = new NativeSignal(target, MouseEvent.MOUSE_OVER, MouseEvent));
			_signals.push(mouseUp = new NativeSignal(target, MouseEvent.MOUSE_UP, MouseEvent));
			_signals.push(mouseWheel = new NativeSignal(target, MouseEvent.MOUSE_WHEEL, MouseEvent));
			_signals.push(rollOut = new NativeSignal(target, MouseEvent.ROLL_OUT, MouseEvent));
			_signals.push(rollOver = new NativeSignal(target, MouseEvent.ROLL_OVER, MouseEvent));
			_signals.push(tabChildrenChange = new NativeSignal(target, Event.TAB_CHILDREN_CHANGE, Event));
			_signals.push(tabEnabledChange = new NativeSignal(target, Event.TAB_ENABLED_CHANGE, Event));
			_signals.push(tabIndexChange = new NativeSignal(target, Event.TAB_INDEX_CHANGE, Event));
			_signals.push(textInput = new NativeSignal(target, TextEvent.TEXT_INPUT, TextEvent));

		}
	}
}

package org.osflash.signals.natives.sets 
{
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
	public class InteractiveObjectSignalSet extends DisplayObjectSignalSet 
	{
		
		public function InteractiveObjectSignalSet(target:InteractiveObject) 
		{
			super(target);
		}

		public function get click():NativeSignal 
		{
			return getNativeSignal(MouseEvent.CLICK, MouseEvent);
		}

		public function get doubleClick():NativeSignal 
		{
			return getNativeSignal(MouseEvent.DOUBLE_CLICK, MouseEvent);
		}

		public function get focusIn():NativeSignal 
		{
			return getNativeSignal(FocusEvent.FOCUS_IN, FocusEvent);
		}

		public function get focusOut():NativeSignal 
		{
			return getNativeSignal(FocusEvent.FOCUS_OUT, FocusEvent);
		}

		public function get keyDown():NativeSignal 
		{
			return getNativeSignal(KeyboardEvent.KEY_DOWN, KeyboardEvent);
		}

		public function get keyFocusChange():NativeSignal 
		{
			return getNativeSignal(FocusEvent.KEY_FOCUS_CHANGE, FocusEvent);
		}

		public function get keyUp():NativeSignal 
		{
			return getNativeSignal(KeyboardEvent.KEY_UP, KeyboardEvent);
		}

		public function get mouseDown():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_DOWN, MouseEvent);
		}

		public function get mouseFocusChange():NativeSignal 
		{
			return getNativeSignal(FocusEvent.MOUSE_FOCUS_CHANGE, FocusEvent);
		}

		public function get mouseMove():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_MOVE, MouseEvent);
		}

		public function get mouseOut():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_OUT, MouseEvent);
		}

		public function get mouseOver():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_OVER, MouseEvent);
		}

		public function get mouseUp():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_UP, MouseEvent);
		}

		public function get mouseWheel():NativeSignal 
		{
			return getNativeSignal(MouseEvent.MOUSE_WHEEL, MouseEvent);
		}

		public function get rollOut():NativeSignal 
		{
			return getNativeSignal(MouseEvent.ROLL_OUT, MouseEvent);
		}

		public function get rollOver():NativeSignal 
		{
			return getNativeSignal(MouseEvent.ROLL_OVER, MouseEvent);
		}

		public function get tabChildrenChange():NativeSignal 
		{
			return getNativeSignal(Event.TAB_CHILDREN_CHANGE);
		}

		public function get tabEnabledChange():NativeSignal 
		{
			return getNativeSignal(Event.TAB_ENABLED_CHANGE);
		}

		public function get tabIndexChange():NativeSignal 
		{
			return getNativeSignal(Event.TAB_INDEX_CHANGE);
		}

		public function get textInput():NativeSignal 
		{
			return getNativeSignal(TextEvent.TEXT_INPUT, TextEvent);
		}
	}
}

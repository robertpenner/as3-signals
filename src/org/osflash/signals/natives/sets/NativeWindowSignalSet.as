package org.osflash.signals.natives.sets
{
import flash.display.NativeWindow;
import flash.events.*;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */
public class NativeWindowSignalSet extends EventDispatcherSignalSet
{
	public function NativeWindowSignalSet(target:NativeWindow)
	{
		super(target);
	}
	
	public function get close():NativeSignal
	{
		return getNativeSignal(Event.CLOSE, Event);
	}
	
	public function get closing():NativeSignal
	{
		return getNativeSignal(Event.CLOSING, Event);
	}
	
	public function get displayStateChange():NativeSignal
	{
		return getNativeSignal(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, NativeWindowDisplayStateEvent);
	}
	
	public function get displayStateChanging():NativeSignal
	{
		return getNativeSignal(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, NativeWindowDisplayStateEvent);
	}
	
	public function get move():NativeSignal
	{
		return getNativeSignal(NativeWindowBoundsEvent.MOVE, NativeWindowBoundsEvent);
	}
	
	public function get moving():NativeSignal
	{
		return getNativeSignal(NativeWindowBoundsEvent.MOVING, NativeWindowBoundsEvent);
	}
	
	public function get resize():NativeSignal
	{
		return getNativeSignal(NativeWindowBoundsEvent.RESIZE, NativeWindowBoundsEvent);
	}
	
	public function get resizing():NativeSignal
	{
		return getNativeSignal(NativeWindowBoundsEvent.RESIZING, NativeWindowBoundsEvent);
	}
	
}//EOC
}//EOP
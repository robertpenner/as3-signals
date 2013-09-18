package org.osflash.signals.natives.sets
{
import fl.controls.BaseButton;
import fl.events.ComponentEvent;
import flash.events.Event;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class BaseButtonSignalSet extends UIComponentSignalSet
{
	public function BaseButtonSignalSet(target:BaseButton)
	{
		super(target);
	}
	
	public function get buttonDown():NativeSignal
	{
		return getNativeSignal(ComponentEvent.BUTTON_DOWN, ComponentEvent);
	}
	
	public function get change():NativeSignal
	{
		return getNativeSignal(Event.CHANGE, ComponentEvent);
	}
	
}//EOC
}//EOP
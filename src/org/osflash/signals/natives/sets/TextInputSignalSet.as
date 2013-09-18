package org.osflash.signals.natives.sets
{
import fl.controls.TextInput;
import fl.events.ComponentEvent;
import flash.events.Event;
import flash.events.TextEvent;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class TextInputSignalSet extends UIComponentSignalSet
{
	public function TextInputSignalSet(target:TextInput)
	{
		super(target);
	}
	
	public function get change():NativeSignal
	{
		return getNativeSignal(Event.CHANGE, Event);
	}
	
	public function get enter():NativeSignal
	{
		return getNativeSignal(ComponentEvent.ENTER, ComponentEvent);
	}
	
}//EOC
}//EOP
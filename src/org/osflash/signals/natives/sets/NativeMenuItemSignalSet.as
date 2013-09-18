package org.osflash.signals.natives.sets
{
import flash.display.NativeMenuItem;
import flash.events.Event;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */
public class NativeMenuItemSignalSet extends EventDispatcherSignalSet
{
	public function NativeMenuItemSignalSet(target:NativeMenuItem)
	{
		super(target);
	}
	
	public function get displaying():NativeSignal
	{
		return getNativeSignal(Event.DISPLAYING, Event);
	}
	
	public function get preparing():NativeSignal
	{
		return getNativeSignal(Event.PREPARING, Event);
	}
	
	public function get select():NativeSignal
	{
		return getNativeSignal(Event.SELECT, Event);
	}
	
}//EOC
}//EOP
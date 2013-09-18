package org.osflash.signals.natives.sets
{
import fl.controls.ComboBox;
import fl.events.ComponentEvent;
import fl.events.ListEvent;
import fl.events.ScrollEvent;
import flash.events.Event;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class ComboBoxSignalSet extends UIComponentSignalSet
{
	public function ComboBoxSignalSet(target:ComboBox)
	{
		super(target);
	}
	
	public function get change():NativeSignal
	{
		return getNativeSignal(Event.CHANGE, Event);
	}
	
	public function get close():NativeSignal
	{
		return getNativeSignal(Event.CLOSE, Event);
	}
	
	
	public function get open():NativeSignal
	{
		return getNativeSignal(Event.OPEN, Event);
	}
	
	public function get enter():NativeSignal
	{
		return getNativeSignal(ComponentEvent.ENTER, ComponentEvent);
	}
	
	public function get itemRollOut():NativeSignal
	{
		return getNativeSignal(ListEvent.ITEM_ROLL_OUT, ListEvent);
	}
	
	public function get itemRollOver():NativeSignal
	{
		return getNativeSignal(ListEvent.ITEM_ROLL_OVER, ListEvent);
	}
	
	public function get scroll():NativeSignal
	{
		return getNativeSignal(ScrollEvent.SCROLL, ScrollEvent);
	}
	
}//EOC
}//EOP
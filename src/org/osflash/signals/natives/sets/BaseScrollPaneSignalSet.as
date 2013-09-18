package org.osflash.signals.natives.sets
{
import fl.containers.BaseScrollPane;
import fl.events.ScrollEvent;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class BaseScrollPaneSignalSet extends UIComponentSignalSet
{
	public function BaseScrollPaneSignalSet(target:BaseScrollPane)
	{
		super(target);
	}
	
	public function get scroll():NativeSignal
	{
		return getNativeSignal(ScrollEvent.SCROLL, ScrollEvent);
	}
	
}//EOC
}//EOP
package org.osflash.signals.natives.sets
{
import fl.controls.LabelButton;
import fl.events.ComponentEvent;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class LabelButtonSignalSet extends BaseButtonSignalSet
{
	public function LabelButtonSignalSet(target:LabelButton)
	{
		super(target);
	}
	
	public function get labelChange():NativeSignal
	{
		return getNativeSignal(ComponentEvent.LABEL_CHANGE, ComponentEvent);
	}
}//EOC
}//EOP
package org.osflash.signals.natives.sets
{
import fl.controls.NumericStepper;
import flash.events.Event;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class NumericStepperSignalSet extends UIComponentSignalSet
{
	public function NumericStepperSignalSet(target:NumericStepper)
	{
		super(target);
	}
	
	public function get change():NativeSignal
	{
		return getNativeSignal(Event.CHANGE , Event);
	}
	
}//EOC
}//EOP
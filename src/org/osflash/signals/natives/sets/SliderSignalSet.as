package org.osflash.signals.natives.sets
{
import fl.controls.Slider;
import fl.events.SliderEvent;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class SliderSignalSet extends UIComponentSignalSet
{
	public function SliderSignalSet(target:Slider)
	{
		super(target);
	}
	
	public function get change():NativeSignal
	{
		return getNativeSignal(SliderEvent.CHANGE , SliderEvent);
	}
	
	public function get thumbDrag():NativeSignal
	{
		return getNativeSignal(SliderEvent.THUMB_DRAG , SliderEvent);
	}
	
	public function get thumbPress():NativeSignal
	{
		return getNativeSignal(SliderEvent.THUMB_PRESS , SliderEvent);
	}
	
	public function get thumbRelease():NativeSignal
	{
		return getNativeSignal(SliderEvent.THUMB_RELEASE , SliderEvent);
	}
	
}//EOC
}//EOP
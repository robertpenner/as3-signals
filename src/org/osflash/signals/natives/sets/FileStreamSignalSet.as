package org.osflash.signals.natives.sets
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.OutputProgressEvent;
import flash.events.ProgressEvent;
import flash.filesystem.FileStream;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class FileStreamSignalSet extends EventDispatcherSignalSet
{
	public function FileStreamSignalSet(target:FileStream)
	{
		super(target);
	}
	
	public function get close():NativeSignal
	{
		return getNativeSignal(Event.CLOSE, Event);
	}
	
	public function get complete():NativeSignal
	{
		return getNativeSignal(Event.COMPLETE, Event);
	}
	
	public function get ioError():NativeSignal
	{
		return getNativeSignal(IOErrorEvent.IO_ERROR, IOErrorEvent);
	}
	
	public function get outputProgress():NativeSignal
	{
		return getNativeSignal(OutputProgressEvent.OUTPUT_PROGRESS, OutputProgressEvent);
	}
	
	public function get progress():NativeSignal
	{
		return getNativeSignal(ProgressEvent.PROGRESS, ProgressEvent);
	}
	
}//EOC
}//EOP
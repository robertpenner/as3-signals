package org.osflash.signals.natives.sets
{
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;
import flash.net.FileReference;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class FileSignalSet extends FileReferenceSignalSet
{
	public function FileSignalSet(target:File)
	{
		super(target);
	}
	
	public function get directoryListing():NativeSignal
	{
		return getNativeSignal(FileListEvent.DIRECTORY_LISTING, FileListEvent);
	}
	
	public function get selectMultiple():NativeSignal
	{
		return getNativeSignal(FileListEvent.SELECT_MULTIPLE, FileListEvent);
	}
	
}//EOC
}//EOP
package org.osflash.signals.natives.sets
{
import fl.controls.DataGrid;
import fl.events.DataGridEvent;
import org.osflash.signals.natives.NativeSignal;

/**
 * 
 * @author Behrooz Tahanzadeh
 * 
 */

public class DataGridSignalSet extends SelectableListSignalSet
{
	public function DataGridSignalSet(target:DataGrid)
	{
		super(target);
	}
	
	public function get columnStretch():NativeSignal
	{
		return getNativeSignal(DataGridEvent.COLUMN_STRETCH, DataGridEvent);
	}
	
	public function get headerRelease():NativeSignal
	{
		return getNativeSignal(DataGridEvent.HEADER_RELEASE, DataGridEvent);
	}
	
	public function get itemEditBegin():NativeSignal
	{
		return getNativeSignal(DataGridEvent.ITEM_EDIT_BEGIN, DataGridEvent);
	}
	
	public function get itemEditBeginning():NativeSignal
	{
		return getNativeSignal(DataGridEvent.ITEM_EDIT_BEGINNING, DataGridEvent);
	}
	
	public function get itemEditEnd():NativeSignal
	{
		return getNativeSignal(DataGridEvent.ITEM_EDIT_END, DataGridEvent);
	}
	
	public function get itemFocusIn():NativeSignal
	{
		return getNativeSignal(DataGridEvent.ITEM_FOCUS_IN, DataGridEvent);
	}
	
	public function get itemFocusOut():NativeSignal
	{
		return getNativeSignal(DataGridEvent.ITEM_FOCUS_OUT, DataGridEvent);
	}
	
}//EOC
}//EOP
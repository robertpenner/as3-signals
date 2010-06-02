package org.osflash.signals.binding 
{
	public interface IChangeSlot 
	{
		function get sourceProperty():String;
		
		function onChange(fromObject:Object, property:String, newValue:Object):void;
		
		function update(newValue:Object):void
	}
}

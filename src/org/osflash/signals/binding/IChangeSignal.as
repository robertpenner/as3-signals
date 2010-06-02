package org.osflash.signals.binding 
{
	public interface IChangeSignal
	{
		function get source():Object;
		
		function addSlot(slot:IChangeSlot):IChangeSlot;
				function removeSlot(slot:IChangeSlot):IChangeSlot;
				function removeAll():void;
		
		function hasSlot(slot:IChangeSlot):Boolean;
		
		function get numSlots():uint;
		
		function dispatch(changedProperty:String, newValue:Object):void;
		
	}
}

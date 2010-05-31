package org.osflash.signals.binding 
{
	import org.osflash.signals.ISignal;

	public interface IChangeSignal extends ISignal
	{
		/**
		 * 
		 * @param	
		 */
		function dispatchChange(property:String, newValue:Object):void;
		
	}
}

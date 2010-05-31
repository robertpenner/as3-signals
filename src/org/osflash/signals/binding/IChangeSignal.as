package org.osflash.signals.binding 
{
	import org.osflash.signals.ISignal;

	public interface IChangeSignal extends ISignal
	{
		/**
		 * 
		 * @param	
		 */
		function dispatchChange(sourceProperty:String, newValue:Object):void;
		
	}
}

package org.osflash.signals.natives
{
	import org.osflash.signals.IPrioritySignal;
	
	/**
	 * INativeSignalOwner gives access to methods that affect all listeners, such as dispatch() and removeAll(). 
	 * This should only be called by trusted classes.
	 */
	public interface INativeSignalOwner extends IPrioritySignal, INativeDispatcher
	{
		/**
		 * Unsubscribes all listeners from the signal.
		 */
		function removeAll():void
	}
}
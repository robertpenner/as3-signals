package org.osflash.signals
{
	/**
	 * ISignalOwner gives access to methods that affect all listeners, such as dispatch() and removeAll(). 
	 * This should only be called by trusted classes.
	 */
	public interface ISignalOwner extends ISignal, IDispatcher
	{
		/**
		 * Unsubscribes all listeners from the signal.
		 */
		function removeAll():void
	}
}
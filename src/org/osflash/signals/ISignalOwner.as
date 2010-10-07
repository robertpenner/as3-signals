package org.osflash.signals
{
	/**
	 * ISignalOwner gives access to the powerful function, removeAll. This should only be called by trusted classes.
	 */
	public interface ISignalOwner extends ISignal
	{
		/**
		 * Unsubscribes all listeners from the signal.
		 */
		function removeAll():void
	}
}
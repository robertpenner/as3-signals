package org.osflash.signals
{
	/**
	 *
	 */
	public interface IDispatcher
	{
		/**
		 * Dispatches an object to listeners.
		 * @param	valueObjects	Any number of parameters to send to listeners. Will be type-checked against valueClasses.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	valueObjects are not compatible with valueClasses.
		 */
		function dispatch(...valueObjects):void;
	}
}

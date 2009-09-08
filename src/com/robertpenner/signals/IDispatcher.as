package com.robertpenner.signals
{
	/**
	 *
	 */
	public interface IDispatcher
	{
		/**
		 * Dispatches an object to listeners.
		 * @param	eventObject		Any object, but an IEvent will take advantage of targeting and bubbling.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	eventObject is not a compatible type, as determined by the IDispatcher.
		 */
		function dispatch(eventObject:Object = null):void;
	}
}

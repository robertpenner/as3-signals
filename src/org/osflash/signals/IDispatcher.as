package org.osflash.signals
{
	/**
	 *
	 */
	public interface IDispatcher
	{
		/**
		 * An optional class reference that enables an event type check in dispatch().
		 */
		function get eventClass():Class;

		/**
		 * Dispatches an object to listeners.
		 * @param	eventObject		Any object, but an IEvent will take advantage of targeting and bubbling.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	eventObject is not compatible with eventClass.
		 */
		function dispatch(eventObject:Object = null):void;
	}
}

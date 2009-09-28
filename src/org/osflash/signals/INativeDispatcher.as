package org.osflash.signals
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 */
	public interface INativeDispatcher
	{
		/**
		 * A class reference that enables an event type check in dispatch().
		 */
		function get eventClass():Class;
		
		/**
		 * The object considered the source of the dispatched events.
		 */
		function get target():IEventDispatcher;

		/**
		 * Dispatches an object to listeners.
		 * @param	eventObject		An instance of a class that is or extends flash.events.Event.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	eventObject is not compatible with eventClass.
		 */
		function dispatch(event:Event):Boolean;
	}
}

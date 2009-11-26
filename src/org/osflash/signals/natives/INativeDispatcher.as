package org.osflash.signals.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Similar to IDispatcher but using strong types specific to Flash's native event system.
	 */
	public interface INativeDispatcher
	{
		/**
		 * The type of event permitted to be dispatched. Corresponds to flash.events.Event.type.
		 */
		function get eventType():String;
		
		/**
		 * The class of event permitted to be dispatched. Will be flash.events.Event or a subclass.
		 */
		function get eventClass():Class;
		
		/**
		 * The object considered the source of the dispatched events.
		 */
		function get target():IEventDispatcher;

		/**
		 * Dispatches an event to listeners.
		 * @param	event			An instance of a class that is or extends flash.events.Event.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	Event object [event] is not an instance of [eventClass].
		 * @throws	ArgumentError	<code>ArgumentError</code>:	Event object has incorrect type. Expected [eventType] but was [event.type].
		 */
		function dispatch(event:Event):Boolean;
	}
}

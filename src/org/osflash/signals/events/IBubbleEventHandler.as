package org.osflash.signals.events
{

	public interface IBubbleEventHandler
	{
		/**
		 * Handler for event bubbling.
		 * It's left to the IBubbleEventHandler to decide what to do with the event.
		 * @param	event The event that bubbled up.
		 */
		function onEventBubbled(event:IEvent):void;
	}
}

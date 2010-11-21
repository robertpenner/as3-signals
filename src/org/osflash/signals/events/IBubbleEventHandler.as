package org.osflash.signals.events
{

	public interface IBubbleEventHandler
	{
		/**
		 * Handler for event bubbling.
		 * It's left to the IBubbleEventHandler to decide what to do with the event.
		 * @param	event The event that bubbled up.
		 * @return whether to continue bubbling this event
		 */
		function onEventBubbled(event:IEvent):Boolean; 
	}
}
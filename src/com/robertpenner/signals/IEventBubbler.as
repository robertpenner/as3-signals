package com.robertpenner.signals
{
	public interface IEventBubbler
	{
		/**
		 * Handler for event bubbling.
		 * It's left up to the IEventBubbler to decide what to do with the event.
		 * @param	event The event that bubbled up.
		 */
		function onEventBubbled(event:IEvent):void;
	}
}
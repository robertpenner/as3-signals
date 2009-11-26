package org.osflash.signals.events
{
	import org.osflash.signals.IDeluxeSignal;

	public interface IEvent
	{
		/** The object that originally dispatched the event.
		 *  When dispatched from an signal, the target is the object containing the signal. */
		function get target():Object;
		function set target(value:Object):void;
		
		/** The object that added the listener for the event. */
		function get currentTarget():Object;
		function set currentTarget(value:Object):void;
		
		/** The signal that dispatched the event. */
		function get signal():IDeluxeSignal;
		function set signal(value:IDeluxeSignal):void;
		
		/** Indicates whether the event is a bubbling event. */
		function get bubbles():Boolean;
		function set bubbles(value:Boolean):void;
		
		/** Returns a new copy of the instance. */
		function clone():IEvent;
	}
}

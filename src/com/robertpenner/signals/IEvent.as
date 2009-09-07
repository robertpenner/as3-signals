package com.robertpenner.signals
{
	public interface IEvent
	{
		/** The object that originally dispatched the event.
		 *  When dispatched from an signal, the target is the object containing the signal. */
		function get target():*;
		function set target(value:*):void;
		
		/** The object that added the listener for the event. */
		function get currentTarget():*;
		function set currentTarget(value:*):void;
		
		/** The signal that dispatched the event. */
		function get signal():ISignal;
		function set signal(value:ISignal):void;
		
		/** Indicates whether the event is a bubbling event. */
		function get bubbles():Boolean;
		function set bubbles(value:Boolean):void;
		
		/** Returns a new copy of the instance. */
		function clone():IEvent;
	}
}
package com.robertpenner.signals
{
	/**
	 * @see com.robertpenner.signals.Signal
	 * Documentation for these methods is being maintained in Signal to avoid duplication for now.
	 */
	public interface ISignal
	{
		function get length():uint;
		
		function get target():*;
		
		function add(listener:Function):void;
		
		function addOnce(listener:Function):void;
		
		function remove(listener:Function):void;
		
		function dispatch(eventObject:Object = null):void;
		
		function removeAll():void;
	}
}

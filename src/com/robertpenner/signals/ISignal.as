package com.robertpenner.signals
{
	public interface ISignal
	{
		function get length():uint;
		
		function get target():*;
		
		function add(listener:Function):void;
		
		function addOnce(listener:Function):void;
		
		function remove(listener:Function):void;
		
		function dispatch(eventObject:Object):void;
		
		function removeAll():void;
	}
}

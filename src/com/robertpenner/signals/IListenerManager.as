package com.robertpenner.signals
{
	/**
	 *
	 */
	public interface IListenerManager
	{
		/** The current number of listeners for the signal. */
		function get length():uint;
		
		/**
		 * Subscribes a listener for the signal.
		 * @param	listener A function with an argument
		 * that matches the type of event dispatched by the signal.
		 * If eventClass is not specified, the listener and dispatch() can called without an argument.
		 */
		function add(listener:Function):void;
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called.
		 * @param	listener A function with an argument
		 * that matches the type of event dispatched by the signal.
		 * If eventClass is not specified, the listener and dispatch() can be called without an argument.
		 */
		function addOnce(listener:Function):void;
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 */
		function remove(listener:Function):void;
		
		/** Unsubscribes all listeners from the signal. */
		function removeAll():void;
		
	}
}

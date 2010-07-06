package org.osflash.signals
{
	/**
	 *
	 */
	public interface ISignal
	{
		/**
		 * An optional array of classes defining the types of parameters sent to listeners.
		 */
		function get valueClasses():Array;
		
		/** The current number of listeners for the signal. */
		function get numListeners():uint;
		
		/**
		 * Subscribes a listener for the signal.
		 * @param	listener A function with arguments
		 * that matches the value classes dispatched by the signal.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 * @return the listener Function passed as the parameter
		 */
		function add(listener:Function):Function;
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called,
		 * after the dispatch to all listeners is complete.
		 * @param	listener A function with arguments
		 * that matches the value classes dispatched by the signal.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 * @return the listener Function passed as the parameter
		 */
		function addOnce(listener:Function):Function;
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 * @return the listener Function passed as the parameter
		 */
		function remove(listener:Function):Function;
		
	}
}

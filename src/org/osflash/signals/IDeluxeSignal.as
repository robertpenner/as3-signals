package org.osflash.signals
{
	/**
	 *
	 */
	public interface IDeluxeSignal
	{
		/**
		 * An optional array of classes defining the types of parameters sent to listeners.
		 */
		function get valueClasses():Array;
		
		/** The current number of listeners for the signal. */
		function get numListeners():uint;
		
		/**
		 * Subscribes a listener for the signal.
		 * After you successfully register an event listener,
		 * you cannot change its priority through additional calls to add().
		 * To change a listener's priority, you must first call remove().
		 * Then you can register the listener again with the new priority level.
		 * @param	listener A function with an argument
		 * that matches the type of event dispatched by the signal.
		 * If eventClass is not specified, the listener and dispatch() can be called without an argument.
		 */
		function add(listener:Function, priority:int = 0):void;
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called,
		 * after the dispatch to all listeners is complete.
		 * @param	listener A function with an argument
		 * that matches the type of event dispatched by the signal.
		 * If eventClass is not specified, the listener and dispatch() can be called without an argument.
		 * @param	priority The priority level of the event listener.
		 * The priority is designated by a signed 32-bit integer.
		 * The higher the number, the higher the priority.
		 * All listeners with priority n are processed before listeners of priority n-1.
		 */
		function addOnce(listener:Function, priority:int = 0):void;
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 */
		function remove(listener:Function):void;
		
	}
}

package org.osflash.signals
{
	/**
	 *
	 */
	public interface IPrioritySignal extends ISignal
	{
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
		function addWithPriority(listener:Function, priority:int = 0):Function
		
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
		function addOnceWithPriority(listener:Function, priority:int = 0):Function
	}
}

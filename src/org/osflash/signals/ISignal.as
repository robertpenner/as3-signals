package org.osflash.signals
{
	/**
	 *
	 */
	public interface ISignal extends IOnceSignal
	{
		/**
		 * Subscribes a listener for the signal.
		 * @param	listener A function with arguments
		 * that matches the value classes dispatched by the signal.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 * @return a ISlot, which contains the Function passed as the parameter
		 */
		function add(listener:Function):ISlot;
	}
}

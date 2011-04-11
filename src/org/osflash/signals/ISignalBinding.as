/**
 * Created by ${PRODUCT_NAME}.
 * User: joa
 * Date: 21.11.10
 * Time: 21:19
 * To change this template use File | Settings | File Templates.
 */
package org.osflash.signals
{
	/**
	 * The ISignalBinding interface defines the basic properties of a
	 * listener associated with a Signal.
	 *
	 * @author Joa Ebert
	 */
	public interface ISignalBinding
	{
		/**
		 * The listener associated with this binding.
		 */
		function get listener():Function;
		function set listener(value:Function):void;
		
		/**
		 * If the binding should use strict mode or not. Useful if you would like to use the ...rest
		 * argument or if you don't want an exact match up of listener arguments and signal 
		 * arguments.
		 */
		function get strict():Boolean;
		function set strict(value:Boolean):void;

		/**
		 * Whether this binding is destroyed after it has been used once.
		 */
		function get once():Boolean;

		/**
		 * The priority of this binding.
		 */
		function get priority():int;
		
		/**
		 * Whether the listener is called on execution. Defaults to true.
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;

		/**
		 * Executes a listener of arity <code>n</code> where <code>n</code> is
		 * <code>valueObjects.length</code>.
		 *
		 * @param valueObjects The array of arguments to be applied to the listener.
		 */
		function execute(valueObjects:Array):void;

		/**
		 * Removes the binding from its signal.
		 */
		function remove(): void;
	}
}

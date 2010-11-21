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
	 * The ISignalSlot interface defines the basic properties of a
	 * listener associated with a Signal.
	 *
	 * @author Joa Ebert
	 */
	public interface ISignalSlot
	{
		/**
		 * The listener associated with this slot.
		 */
		function get listener():Function;

		/**
		 * Whether or not this slot is destroyed after it has been used.
		 */
		function get isOnce():Boolean;

		/**
		 * The priority of this slot.
		 */
		function get priority(): int;

		/**
		 * Executes a listener of arity <code>n</code> where <code>n</code> is
		 * <code>valueObjects.length</code>.
		 *
		 * @param valueObjects The array of arguments to be applied to the listener.
		 */
		function execute(valueObjects:Array):void;

		/**
		 * Executes a listener of arity <code>0</code>.
		 */
		function execute0():void;

		/**
		 * Executes a listener of arity <code>1</code>.
		 *
		 * @param value1 The argument for the listener.
		 */
		function execute1(value1:Object):void;

		/**
		 * Executes a listener of arity <code>2</code>.
		 *
		 * @param value1 The first argument for the listener.
		 * @param value2 The second argument for the listener.
		 */
		function execute2(value1:Object, value2:Object):void;
	}
}

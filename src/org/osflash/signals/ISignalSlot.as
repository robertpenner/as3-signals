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
		
		function execute(valueObjects:Array):void;

		function execute0():void;

		function execute1(value1:Object):void;

		function execute2(value1:Object, value2:Object):void;
	}
}

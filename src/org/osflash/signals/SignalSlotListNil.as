/**
 * Created by ${PRODUCT_NAME}.
 * User: joa
 * Date: 21.11.10
 * Time: 22:42
 * To change this template use File | Settings | File Templates.
 */
package org.osflash.signals
{
	internal final class SignalSlotListNil implements ISignalSlotList
	{
		public function prepend(value:SignalSlot):SignalSlotList
		{
			return SignalSlotList.create(value, this);
		}

		public function indexOf(value:Function):int
		{
			return -1;
		}

		public function filterNot(listener:Function):ISignalSlotList
		{
			return this;
		}

		public function get length():int
		{
			return 0;
		}

		public function get isEmpty():Boolean
		{
			return true;
		}

		public function get nonEmpty():Boolean
		{
			return false;
		}

		public function get head():SignalSlot
		{
			throw new Error('Cannot get head of empty list.')
		}

		public function get tail():ISignalSlotList
		{
			throw new Error('Cannot get head of empty list.')
		}
	}
}

package org.osflash.signals
{
	public interface ISignalSlotList
	{
		function prepend(value:SignalSlot):SignalSlotList;

		function indexOf(value:Function):int;

		function filterNot(listener:Function):ISignalSlotList;

		function contains(listener:Function):Boolean;

		function find(listener: Function): SignalSlot;

		function clear():SignalSlotListNil;

		function get length(): int;

		function get isEmpty(): Boolean;

		function get nonEmpty(): Boolean;

		function get head(): SignalSlot;

		function get tail(): ISignalSlotList;
	}
}

package org.osflash.signals
{
	internal final class SignalSlotList implements ISignalSlotList
	{
		//todo pool me, however its complicated
		internal static function create(head:SignalSlot, tail:ISignalSlotList): SignalSlotList
		{
			const result: SignalSlotList = new SignalSlotList();

			result._head = head;
			result._tail = tail;

			return result;
		}

		private var _head: SignalSlot;
		private var _tail: ISignalSlotList;

		public function get head():SignalSlot
		{
			return _head;
		}

		public function get tail():ISignalSlotList
		{
			return _tail;
		}

		public function get length():int
		{
			//of course we could cache this	and get rid of O(n) but it
			//is only used for numListeners on signal

			var result:int = 0;
			var p:SignalSlotList = this;

			while (p.nonEmpty)
			{
				++result;
			}

			return result;
		}

		public function get nonEmpty(): Boolean
		{
			return true;
		}

		public function get isEmpty(): Boolean
		{
			return false;
		}

		public function prepend(value:SignalSlot):SignalSlotList
		{
			return create(value, this);
		}

		public function indexOf(value:Function):int
		{
			var index:int = 0;
			var p:ISignalSlotList = this;

			while (p.nonEmpty)
			{
				if (p.head._listener == value)
				{
					return index;
				}

				p = p.tail;
				++index;
			}

			return -1;
		}

		public function filterNot(listener:Function):ISignalSlotList
		{
			//optimize the case that listener is first element
			if (listener == _head._listener)
			{
				return _tail;
			}

			var p:ISignalSlotList = this;
			var q:SignalSlotList = null;

			var first:SignalSlotList = null;
			var last:SignalSlotList = null;
			var allFiltered:Boolean = true;

			while (p.nonEmpty)
			{
				if (p.head._listener != listener)
				{
					q = create(p.head, nil);

					if (null != last)
					{
						last._tail = q;
					}

					if (null == first)
					{
						first = q;
					}

					last = q;
				}
				else
				{
					SlotPool.markDead(q.head);
					allFiltered = false
				}

				p = p.tail;
			}

			if (allFiltered)
			{
				return this;
			}

			return (first == null) ? nil : first;
		}

		public function contains(listener:Function):Boolean
		{
			return false;
		}

		public function clear():SignalSlotListNil
		{
			var p:ISignalSlotList = this;

			while (p.nonEmpty)
			{
				SlotPool.markDead(p.head);
				p = p.tail;
			}

			return nil;
		}

		public function find(listener:Function):SignalSlot
		{
			var p:ISignalSlotList = this;

			while (p.nonEmpty)
			{
				if(p.head._listener == listener)
				{
					return p.head;
				}

				p = p.tail;
			}

			return null;
		}
	}
}

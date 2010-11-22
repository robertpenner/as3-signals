package org.osflash.signals
{
	/**
	 * The SignalSlotList class represents an immutable list of SignalSlot objects.
	 *
	 * @author Joa Ebert
	 */
	internal final class SignalSlotList
	{
		public static const NIL: SignalSlotList = new SignalSlotList(null, null);

		/**
		 * Creates and returns a new SignalSlotList object.
		 *
		 * <p>A user never has to create a SignalSlotList manually. Use the <code>NIL</code> element to represent an
		 * empty list. <code>NIL.prepend(value)</code> would create a list containing <code>value</code>.
		 *
		 * @private
		 * 
		 * @param head The head of the list.
		 * @param tail The tail of the list.
		 */
		public function SignalSlotList(head:SignalSlot, tail:SignalSlotList)
		{
			if(null == head && null == tail)
			{
				if(null != NIL) throw new ArgumentError(
						'Parameters head and tail are null. Use the NIL element instead.');

				//this is the NIL element per definition
				isEmpty = true;
				nonEmpty = false;
			}
			else
			{
				if(null == tail) throw new ArgumentError('Tail must not be null.');

				this.head = head;
				this.tail = tail;
				isEmpty = false;
				nonEmpty = true;
			}
		}

		//
		// Although those variables are not const, they would be if AS3 would handle it correct.
		//

		public var head: SignalSlot;
		public var tail: SignalSlotList;
		public var nonEmpty: Boolean;
		public var isEmpty: Boolean;

		/**
		 * The length of the list.
		 */
		public function get length():int
		{
			if (isEmpty) return 0;

			//
			// We could cache the length, but it would make methods like filterNot unnecessarily complicated.
			// Instead we assume that O(n) is okay since the length property is used in rare cases.
			// We could also cache the length lazy, but that is a waste of another 8b per list node (at least).
			//

			var result: int = 0;
			var p:SignalSlotList = this;

			while (p.nonEmpty)
			{
				++result;
				p = p.tail;
			}

			return result;
		}

		public function prepend(value:SignalSlot):SignalSlotList
		{
			return new SignalSlotList(value, this);
		}

		public function insertWithPriority(value: SignalSlot):SignalSlotList
		{
			if (isEmpty) return new SignalSlotList(value, this);

			const priority: int = value._priority;

			if(priority > this.head._priority) return new SignalSlotList(value, this);

			var p:SignalSlotList = this;
			var q:SignalSlotList = null;

			var first:SignalSlotList = null;
			var last:SignalSlotList = null;

			while (p.nonEmpty)
			{
				if (priority > p.head._priority)
				{
					q = new SignalSlotList(value, p);

					if(null != last) last.tail = q;

					return q;
				}
				else
				{
					q = new SignalSlotList(p.head, NIL);

					if (null != last) last.tail = q;
					if (null == first) first = q;

					last = q;
				}

				p = p.tail;
			}

			if (first == null || last == null) throw new Error('Internal error.');

			last.tail = new SignalSlotList(value, NIL);

			return first;
		}

		public function indexOf(value:Function):int
		{
			if (isEmpty) return -1;

			var index:int = 0;
			var p:SignalSlotList = this;

			while (p.nonEmpty)
			{
				if (p.head._listener == value) return index;

				p = p.tail;
				++index;
			}

			return -1;
		}

		public function filterNot(listener:Function):SignalSlotList
		{
			if (isEmpty) return this;

			if (listener == head._listener) return tail;

			var p:SignalSlotList = this;
			var q:SignalSlotList = null;

			var first:SignalSlotList = null;
			var last:SignalSlotList = null;
			var allFiltered:Boolean = true;

			while (p.nonEmpty)
			{
				if (p.head._listener != listener)
				{
					q = new SignalSlotList(p.head, NIL);

					if (null != last) last.tail = q;
					if (null == first) first = q;

					last = q;
				}
				else
				{
					allFiltered = false;
				}

				p = p.tail;
			}

			if (allFiltered) return this;
			else if (first == null) return NIL;
			else return first;
		}

		public function contains(listener:Function):Boolean
		{
			if (isEmpty) return false;

			var p:SignalSlotList = this;

			while (p.nonEmpty)
			{
				if(p.head._listener == listener) return true;

				p = p.tail;
			}

			return false;
		}

		public function find(listener:Function):SignalSlot
		{
			if (isEmpty) return null; 

			var p:SignalSlotList = this;

			while (p.nonEmpty)
			{
				if(p.head._listener == listener) return p.head;

				p = p.tail;
			}

			return null;
		}

		public function toString(): String
		{
			var buffer:String = '';
			var p:SignalSlotList = this;

			while (p.nonEmpty) buffer += p.head+" -> ";

			buffer += "Nil";

			return "[List "+buffer+"]"
		}
	}
}

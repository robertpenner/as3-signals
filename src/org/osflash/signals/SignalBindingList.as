package org.osflash.signals
{
	/**
	 * The SignalBindingList class represents an immutable list of SignalBinding objects.
	 *
	 * @author Joa Ebert
	 * @private
	 */
	public final class SignalBindingList
	{
		public static const NIL: SignalBindingList = new SignalBindingList(null, null);

		/**
		 * Creates and returns a new SignalBindingList object.
		 *
		 * <p>A user never has to create a SignalBindingList manually. Use the <code>NIL</code> element to represent an
		 * empty list. <code>NIL.prepend(value)</code> would create a list containing <code>value</code>.
		 *
		 * @param head The head of the list.
		 * @param tail The tail of the list.
		 */
		public function SignalBindingList(head:ISignalBinding, tail:SignalBindingList)
		{
			if(null == head && null == tail)
			{
				if(null != NIL) throw new ArgumentError(
						'Parameters head and tail are null. Use the NIL element instead.');

				//this is the NIL element per definition
				nonEmpty = false;
			}
			else
			{
				if(null == tail) throw new ArgumentError('Tail must not be null.');

				this.head = head;
				this.tail = tail;
				nonEmpty = true;
			}
		}

		//
		// Although those variables are not const, they would be if AS3 would handle it correct.
		//

		public var head: ISignalBinding;
		public var tail: SignalBindingList;
		public var nonEmpty: Boolean;

		/**
		 * Whether or not the list is empty.
		 *
		 * <code>isEmpty</code> is the same as <code>!nonEmpty</code>. If performance is a criteria one should always
		 * use the <code>nonEmpty</code> method. <code>isEmpty</code> is only a wrapper for convinience.
		 */
		public function get isEmpty():Boolean
		{
			return !nonEmpty;
		}

		/**
		 * The length of the list.
		 */
		public function get length():uint
		{
			if (!nonEmpty) return 0;

			//
			// We could cache the length, but it would make methods like filterNot unnecessarily complicated.
			// Instead we assume that O(n) is okay since the length property is used in rare cases.
			// We could also cache the length lazy, but that is a waste of another 8b per list node (at least).
			//

			var result:uint = 0;
			var p:SignalBindingList = this;

			while (p.nonEmpty)
			{
				++result;
				p = p.tail;
			}

			return result;
		}

		public function prepend(value:SignalBinding):SignalBindingList
		{
			return new SignalBindingList(value, this);
		}

		public function insertWithPriority(value: ISignalBinding):SignalBindingList
		{
			if (!nonEmpty) return new SignalBindingList(value, this);

			const priority: int = value.priority;

			if(priority > this.head.priority) return new SignalBindingList(value, this);

			var p:SignalBindingList = this;
			var q:SignalBindingList = null;

			var first:SignalBindingList = null;
			var last:SignalBindingList = null;

			while (p.nonEmpty)
			{
				if (priority > p.head.priority)
				{
					q = new SignalBindingList(value, p);

					if(null != last) last.tail = q;

					return q;
				}
				else
				{
					q = new SignalBindingList(p.head, NIL);

					if (null != last) last.tail = q;
					if (null == first) first = q;

					last = q;
				}

				p = p.tail;
			}

			if (first == null || last == null) throw new Error('Internal error.');

			last.tail = new SignalBindingList(value, NIL);

			return first;
		}

		public function filterNot(listener:Function):SignalBindingList
		{
			if (!nonEmpty || listener == null) return this;

			if (listener == head.listener) return tail;

			// The first item wasn't a match so the filtered list will contain it.
			const first:SignalBindingList = new SignalBindingList(head, NIL);
			var current:SignalBindingList = tail;
			var previous:SignalBindingList = first;
			
			while (current.nonEmpty)
			{
				if (current.head.listener == listener)
				{
					// Splice out the current head.
					previous.tail = current.tail;
					return first;
				}
				
				previous = previous.tail = new SignalBindingList(current.head, NIL);
				current = current.tail;
			}

			// The listener was not found so this list is unchanged.
			return this;
		}

		public function contains(listener:Function):Boolean
		{
			if (!nonEmpty) return false;

			var p:SignalBindingList = this;

			while (p.nonEmpty)
			{
				if (p.head.listener == listener) return true;

				p = p.tail;
			}

			return false;
		}

		public function find(listener:Function):ISignalBinding
		{
			if (!nonEmpty) return null;

			var p:SignalBindingList = this;

			while (p.nonEmpty)
			{
				if (p.head.listener == listener) return p.head;

				p = p.tail;
			}

			return null;
		}

		public function toString():String
		{
			var buffer:String = '';
			var p:SignalBindingList = this;

			while (p.nonEmpty)
			{
				buffer += p.head + " -> ";
				p = p.tail;
			}

			buffer += "Nil";

			return "[List "+buffer+"]";
		}
	}
}

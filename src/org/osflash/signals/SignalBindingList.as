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
		public static const NIL:SignalBindingList = new SignalBindingList(null, null);

		/**
		 * Creates and returns a new SignalBindingList object.
		 *
		 * <p>A user never has to create a SignalBindingList manually. Use the <code>NIL</code> element to represent an
		 * empty list. <code>NIL.prepend(value)</code> would create a list containing <code>value</code>.
		 *
		 * @param head The head of the list.
		 * @param tail The tail of the list.
		 */
		public function SignalBindingList(head:ISignalBinding, tail:SignalBindingList = null)
		{
			if (!head && !tail)
			{
				if (NIL) throw new ArgumentError(
						'Parameters head and tail are null. Use the NIL element instead.');

				//this is the NIL element as per definition
				nonEmpty = false;
			}
			else
			{
				this.head = head;
				this.tail = tail || NIL;
				nonEmpty = true;
			}
		}

		// Although those variables are not const, they would be if AS3 would handle it correctly.
		public var head:ISignalBinding;
		public var tail:SignalBindingList;
		public var nonEmpty:Boolean = false;

		/**
		 * The length of the list.
		 */
		public function get length():uint
		{
			if (!nonEmpty) return 0;
			if (tail == NIL) return 1;

			// We could cache the length, but it would make methods like filterNot unnecessarily complicated.
			// Instead we assume that O(n) is okay since the length property is used in rare cases.
			// We could also cache the length lazy, but that is a waste of another 8b per list node (at least).

			var result:uint = 0;
			var p:SignalBindingList = this;

			while (p.nonEmpty)
			{
				++result;
				p = p.tail;
			}

			return result;
		}
		
		public function prepend(binding:ISignalBinding):SignalBindingList
		{
			return new SignalBindingList(binding, this);
		}

		/**
		 * Clones the list and adds a binding to the end.
		 * @param	binding
		 * @return	A new list with the binding appended to the end.
		 */
		public function append(binding:ISignalBinding):SignalBindingList
		{
			if (!binding) return this;
			if (!nonEmpty) return new SignalBindingList(binding);
			// Special case: just one binding.
			if (tail == NIL) 
				return new SignalBindingList(binding).prepend(head);
			
			const wholeClone:SignalBindingList = new SignalBindingList(head);
			var subClone:SignalBindingList = wholeClone;
			var current:SignalBindingList = tail;

			while (current.nonEmpty)
			{
				subClone = subClone.tail = new SignalBindingList(current.head);
				current = current.tail;
			}
			// Append the new binding last.
			subClone.tail = new SignalBindingList(binding);
			return wholeClone;
		}		
		
		public function insertWithPriority(binding:ISignalBinding):SignalBindingList
		{
			if (!nonEmpty) return new SignalBindingList(binding);

			const priority:int = binding.priority;
			// Special case: new binding has the highest priority.
			if (priority > this.head.priority) return prepend(binding);

			var q:SignalBindingList = null;
			const wholeClone:SignalBindingList = new SignalBindingList(head);
			var subClone:SignalBindingList = wholeClone;
			var current:SignalBindingList = tail;

			// Find a binding with lower priority and go in front of it.
			while (current.nonEmpty)
			{
				if (priority > current.head.priority)
				{
					const newTail : SignalBindingList = current.prepend(binding);
					return new SignalBindingList(head, newTail);
				}
				
				subClone = subClone.tail = new SignalBindingList(current.head);
				current = current.tail;
			}


			// Binding has lowest priority.
			subClone.tail = new SignalBindingList(binding);
			return wholeClone;
		}
		
		public function filterNot(listener:Function):SignalBindingList
		{
			if (!nonEmpty || listener == null) return this;

			if (listener == head.listener) return tail;

			// The first item wasn't a match so the filtered list will contain it.
			const wholeClone:SignalBindingList = new SignalBindingList(head);
			var subClone:SignalBindingList = wholeClone;
			var current:SignalBindingList = tail;
			
			while (current.nonEmpty)
			{
				if (current.head.listener == listener)
				{
					// Splice out the current head.
					subClone.tail = current.tail;
					return wholeClone;
				}
				
				subClone = subClone.tail = new SignalBindingList(current.head);
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

			buffer += "NIL";

			return "[List "+buffer+"]";
		}
	}
}

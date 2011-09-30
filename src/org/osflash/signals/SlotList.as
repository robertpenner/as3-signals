package org.osflash.signals
{
	/**
	 * The SlotList class represents an immutable list of Slot objects.
	 *
	 * @author Joa Ebert
	 * @author Robert Penner
	 */
	public final class SlotList
	{
		/**
		 * Represents an empty list. Used as the list terminator.
		 */
		public static const NIL:SlotList = new SlotList(null, null);

		/**
		 * Creates and returns a new SlotList object.
		 *
		 * <p>A user never has to create a SlotList manually. 
		 * Use the <code>NIL</code> element to represent an empty list. 
		 * <code>NIL.prepend(value)</code> would create a list containing <code>value</code></p>.
		 *
		 * @param head The first slot in the list.
		 * @param tail A list containing all slots except head.
		 * 
		 * @throws ArgumentError <code>ArgumentError</code>: Parameters head and tail are null. Use the NIL element instead.
		 * @throws ArgumentError <code>ArgumentError</code>: Parameter head cannot be null.
		 */
		public function SlotList(head:ISlot, tail:SlotList = null)
		{
			if (!head && !tail)
			{
				if (NIL) 
					throw new ArgumentError('Parameters head and tail are null. Use the NIL element instead.');
					
				//this is the NIL element as per definition
				nonEmpty = false;
			}
			else if (!head)
			{
				throw new ArgumentError('Parameter head cannot be null.');
			}
			else
			{
				this.head = head;
				this.tail = tail || NIL;
				nonEmpty = true;
			}
		}

		// Although those variables are not const, they would be if AS3 would handle it correctly.
		public var head:ISlot;
		public var tail:SlotList;
		public var nonEmpty:Boolean = false;

		/**
		 * The number of slots in the list.
		 */
		public function get length():uint
		{
			if (!nonEmpty) return 0;
			if (tail == NIL) return 1;

			// We could cache the length, but it would make methods like filterNot unnecessarily complicated.
			// Instead we assume that O(n) is okay since the length property is used in rare cases.
			// We could also cache the length lazy, but that is a waste of another 8b per list node (at least).

			var result:uint = 0;
			var p:SlotList = this;

			while (p.nonEmpty)
			{
				++result;
				p = p.tail;
			}

			return result;
		}
		
		/**
		 * Prepends a slot to this list.
		 * @param	slot The item to be prepended.
		 * @return	A list consisting of slot followed by all elements of this list.
		 * 
		 * @throws ArgumentError <code>ArgumentError</code>: Parameter head cannot be null.
		 */
		public function prepend(slot:ISlot):SlotList
		{
			return new SlotList(slot, this);
		}

		/**
		 * Appends a slot to this list.
		 * Note: appending is O(n). Where possible, prepend which is O(1).
		 * In some cases, many list items must be cloned to 
		 * avoid changing existing lists.
		 * @param	slot The item to be appended.
		 * @return	A list consisting of all elements of this list followed by slot.
		 */
		public function append(slot:ISlot):SlotList
		{
			if (!slot) return this;
			if (!nonEmpty) return new SlotList(slot);
			// Special case: just one slot currently in the list.
			if (tail == NIL) 
				return new SlotList(slot).prepend(head);
			
			// The list already has two or more slots.
			// We have to build a new list with cloned items because they are immutable.
			const wholeClone:SlotList = new SlotList(head);
			var subClone:SlotList = wholeClone;
			var current:SlotList = tail;

			while (current.nonEmpty)
			{
				subClone = subClone.tail = new SlotList(current.head);
				current = current.tail;
			}
			// Append the new slot last.
			subClone.tail = new SlotList(slot);
			return wholeClone;
		}		
		
		/**
		 * Insert a slot into the list in a position according to its priority.
		 * The higher the priority, the closer the item will be inserted to the list head.
		 * @params slot The item to be inserted.
		 * 
		 * @throws ArgumentError <code>ArgumentError</code>: Parameters head and tail are null. Use the NIL element instead.
		 * @throws ArgumentError <code>ArgumentError</code>: Parameter head cannot be null.
		 */
		public function insertWithPriority(slot:ISlot):SlotList
		{
			if (!nonEmpty) return new SlotList(slot);

			const priority:int = slot.priority;
			// Special case: new slot has the highest priority.
			if (priority > this.head.priority) return prepend(slot);

			const wholeClone:SlotList = new SlotList(head);
			var subClone:SlotList = wholeClone;
			var current:SlotList = tail;

			// Find a slot with lower priority and go in front of it.
			while (current.nonEmpty)
			{
				if (priority > current.head.priority)
				{
					subClone.tail = current.prepend(slot);
					return wholeClone; 
				}			
				subClone = subClone.tail = new SlotList(current.head);
				current = current.tail;
			}

			// Slot has lowest priority.
			subClone.tail = new SlotList(slot);
			return wholeClone;
		}
		
		/**
		 * Returns the slots in this list that do not contain the supplied listener.
		 * Note: assumes the listener is not repeated within the list.
		 * @param	listener The function to remove.
		 * @return A list consisting of all elements of this list that do not have listener.
		 */
		public function filterNot(listener:Function):SlotList
		{
			if (!nonEmpty || listener == null) return this;

			if (listener == head.listener) return tail;

			// The first item wasn't a match so the filtered list will contain it.
			const wholeClone:SlotList = new SlotList(head);
			var subClone:SlotList = wholeClone;
			var current:SlotList = tail;
			
			while (current.nonEmpty)
			{
				if (current.head.listener == listener)
				{
					// Splice out the current head.
					subClone.tail = current.tail;
					return wholeClone;
				}
				
				subClone = subClone.tail = new SlotList(current.head);
				current = current.tail;
			}

			// The listener was not found so this list is unchanged.
			return this;
		}

		/**
		 * Determines whether the supplied listener Function is contained within this list
		 */
		public function contains(listener:Function):Boolean
		{
			if (!nonEmpty) return false;

			var p:SlotList = this;
			while (p.nonEmpty)
			{
				if (p.head.listener == listener) return true;
				p = p.tail;
			}

			return false;
		}

		/**
		 * Retrieves the ISlot associated with a supplied listener within the SlotList.
		 * @param   listener The Function being searched for
		 * @return  The ISlot in this list associated with the listener parameter through the ISlot.listener property.
		 *          Returns null if no such ISlot instance exists or the list is empty.  
		 */
		public function find(listener:Function):ISlot
		{
			if (!nonEmpty) return null;

			var p:SlotList = this;
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
			var p:SlotList = this;

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

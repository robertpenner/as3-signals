package org.osflash.signals.binding 
{
	public class ChangeSignal implements IChangeSignal
	{
		protected var _source:Object;
        protected var slots:Array = [];
        protected var slotsNeedCopying:Boolean;

		public function ChangeSignal(source:Object)
		{
			this._source = source;
		}
		
		public function get source():Object { return _source; }
		
        /**
         *   Add a slot to be called during dispatch
         *
         *   @param slot IChangeSlot to add or a Functin to add via a ChangeFunctionSlot
         *   This method has no effect if the slot is null or the signal already has the slot.
         */
        public function addSlot(slot:IChangeSlot):IChangeSlot
        {
			// Only add valid slots we don't already have
			if (hasSlot(slot)) return slot;			
			// Copy the list during dispatch
			if (slotsNeedCopying)
			{
			    slots = slots.slice();
			    slotsNeedCopying = false;
			}			
			return (slots[slots.length] = slot);
        }
        
        /**
         *   
         *
         *   @param slot
         */
        public function removeSlot(slot:IChangeSlot):IChangeSlot
        {
            // Can't remove a slot we don't have
            var index:int = slots.indexOf(slot);
            if (index < 0) return slot;

            // Copy the list during dispatch
            if(slotsNeedCopying)
            {
                slots = slots.slice();
                slotsNeedCopying = false;
            }

            slots.splice(index, 1);
            return slot; 
        }
        
        /**
         *   Remove all slots so that they are not called during dispatch
         */
        public function removeAll():void
        {
            if(slotsNeedCopying)
            {
                slots = [];
                slotsNeedCopying = false;
            }
            else
            {
                slots.length = 0;
            }
        }
        
        /**
         *   Check if the signal has a slot
         *
         *   @param slot Slot to check
         *   @return If the signal has the given slot
         */
        public function hasSlot(slot:IChangeSlot):Boolean
        {
            return slots.indexOf(slot) >= 0;
        }
        
        /**
         *   Get the number of slots the signal has
         *
         *   @return The number of slots the signal has
         */
        public function get numSlots():uint
        {
            return slots.length;
        }
        
        /**
         *   Call all of the slots the signal has. Calls to add() or remove() by any slot in response to these
         *   calls will not change which slots are called or the order in which they are called during
         *   this particular dispatch.
         *
         *   @param newValue Argument to pass to the slots
         */
        public function dispatch(changedProperty:String, newValue:Object):void
        {
            slotsNeedCopying = true;

            for each (var slot:IChangeSlot in slots)
            {
	           	if (slot.sourceProperty != changedProperty) continue;
                slot.update(newValue);
            }

			slotsNeedCopying = false;
		}
		
	}
}

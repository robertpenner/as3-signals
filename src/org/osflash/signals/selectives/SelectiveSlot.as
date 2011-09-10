package org.osflash.signals.selectives {

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Slot;
	
	/**
	 * @inheritDoc
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public class SelectiveSlot extends Slot implements ISelectiveSlot {

		/**
		 * Holds selectivity-value
		 */
		protected var _value:Object = null;

		/**
		 * Creates a new SelectiveSlot for given listener 
		 * 
		 * @param   listener    Listener associated with the slot
		 * @param   signal      Signal associated with the slot
		 * @param   value       Selectivity-value this slot uses for selective dispatching
		 * @param   once        Whether the listener should be executed only once
		 * @param   priority    Priority of the slot
		 */
		public function SelectiveSlot(listener:Function, signal:ISignal, value:Object, once:Boolean=false, priority:int=0) {
			super(listener, signal, once, priority);
			
			_value = value;
		}
		
		/**
		 * Returns the human-readable string representation of this slot
		 */
		override public function toString():String {
			return '[SelectiveSlot; Value: ' + _value + '; Once: ' + _once + '; Priority: ' + _priority + ', Enabled: ' + _enabled + ']';
		}

		/**
		 * @inheritDoc
		 */
		public function get value():Object {
			return _value;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:Object):void {
			_value = value;
		}
		
	}
	
}

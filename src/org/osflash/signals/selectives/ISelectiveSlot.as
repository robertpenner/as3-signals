package org.osflash.signals.selectives {
	
	import org.osflash.signals.ISlot;
	
	/**
	 * Denotes a slot which is used for selective dispatching
	 * 
	 * This type of slot holds a required selectivity-value, which is compared 
	 * during dispatch. The slot is only executed if the value matches.
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public interface ISelectiveSlot extends ISlot {
		
		/**
		 * Gets selectivity-value for this slot
		 */
		function get value():Object;
		
		/**
		 * Sets selectivity-value for this slot
		 */
		function set value(value:Object):void;
		
	}
	
}

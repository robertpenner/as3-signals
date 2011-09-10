package org.osflash.signals.selectives {
	
	import org.osflash.signals.IPrioritySignal;
	
	/**
	 * Denotes a signal capable of selective dispatching
	 * 
	 * Only the listeners that are selectively listening are executed. Each slot allows 
	 * registration of a so-called selectivity-value, which is compared during dispatch.
	 * 
	 * @see     SelectiveSignal
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public interface ISelectiveSignal extends IPrioritySignal {
		
		/**
		 * Gets the provider for this signal
		 */
		function get provider():Function;
		
		/**
		 * Sets the provider for this signal
		 */
		function set provider(provider:Function):void;
		
		/**
		 * Subscribes a selective listener for this signal
		 * 
		 * @param   value       Selectivity value which allows for selective dispatching
		 * @param   listener    Function with arguments that matches value classes
		 * 
		 * @return  an ISelectiveSlot, which holds both selectivity-value and listener
		 */
		function addFor(value:Object, listener:Function):ISelectiveSlot;
		
		/**
		 * Subscribes a one-time selective listener for this signal
		 * 
		 * @param   value       Selectivity value which allows for selective dispatching
		 * @param   listener    Function with arguments that matches value classes
		 * 
		 * @return  an ISelectiveSlot, which holds both selectivity-value and listener
		 */
		function addOnceFor(value:Object, listener:Function):ISelectiveSlot;

		/**
		 * Subscribes a selective listener for this signal with given priority
		 * 
		 * @param   value       Selectivity value which allows for selective dispatching
		 * @param   listener    Function with arguments that matches value classes
		 * @param   priority    Listeners execute in order of high to low priority
		 * 
		 * @return  an ISelectiveSlot, which holds both selectivity-value and listener
		 */
		function addWithPriorityFor(value:Object, listener:Function, priority:int=0):ISelectiveSlot;
		
		/**
		 * Subscribes a one-time selective listener for this signal with given priority
		 * 
		 * @param   value       Selectivity value which allows for selective dispatching
		 * @param   listener    Function with arguments that matches value classes
		 * @param   priority    Listeners execute in order of high to low priority
		 * 
		 * @return  an ISelectiveSlot, which holds both selectivity-value and listener
		 */
		function addOnceWithPriorityFor(value:Object, listener:Function, priority:int=0):ISelectiveSlot;
		
	}
	
}

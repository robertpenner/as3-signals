package org.osflash.signals.selectives.natives {

	import org.osflash.signals.natives.INativeDispatcher;
	import org.osflash.signals.selectives.ISelectiveSignal;
	
	/**
	 * Denotes a native signal capable of selective dispatching
	 * 
	 * Only the listeners that are selectively listening are executed. Each slot allows 
	 * registration of a so-called selectivity-value, which is compared during dispatch.
	 * 
	 * @see     SelectiveNativeRelaySignal
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public interface ISelectiveNativeSignal extends INativeDispatcher, ISelectiveSignal {
		
		
		
	}
	
}

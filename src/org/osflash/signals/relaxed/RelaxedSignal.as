package org.osflash.signals.relaxed
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.ISlot;
	
	public class RelaxedSignal extends RelaxedOnceSignal implements ISignal
	{
		public function RelaxedSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			super(valueClasses);
		}
		
		public function add(listener:Function):ISlot
		{
			return null;
		}
	}
}
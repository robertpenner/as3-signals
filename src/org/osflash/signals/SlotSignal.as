package org.osflash.signals
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SlotSignal extends Signal
	{
		/**
		 * Creates a SlotSignal instance to dispatch arguments that are less than the ammount of
		 * valueClasses passed in via the constructor.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, var signal : SlotSignal = new SlotSignal(String, uint)
		 * would allow: signal.add(function(s:String):void{})
		 * 
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function SlotSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			
			super(valueClasses);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function registerListener(listener:Function, once:Boolean = false):ISignalBinding
		{
			if (registrationPossible(listener, once))
			{
				const binding:ISignalBinding = new SlotSignalBinding(listener, once, this);
				bindings = new SignalBindingList(binding, bindings);
				return binding;
			}
			
			return bindings.find(listener);
		}
	}
}

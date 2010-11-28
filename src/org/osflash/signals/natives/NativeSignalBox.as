package org.osflash.signals.natives
{
	/**
	 * @author simonrichardson
	 */
	internal class NativeSignalBox
	{
		
		public var listener : Function;
		
		public var once : Boolean;
		
		public var execute : Function;
		
		public function NativeSignalBox(listener : Function, once : Boolean, execute : Function)
		{
			this.listener = listener;
			this.once = once;
			this.execute = execute;
		}

	}
}

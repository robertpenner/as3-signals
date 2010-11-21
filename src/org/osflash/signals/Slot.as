package org.osflash.signals 
{
    /**
     * The Slot class represents a signal slot.
     *
     * @author Robert Penner
     */
	internal final class Slot
	{
		public var listener:Function;
		public var once:Boolean;
		public var priority:int;
		private var signal:ISignal;
		
		public function Slot(listener:Function, once:Boolean = false, signal:ISignal = null, priority:int = 0)
		{
			this.listener = listener;
			this.once = once;
			this.signal = signal;
			this.priority = priority;
		}
		
		public function execute(valueObjects:Array):void
		{
			if (once) signal.remove(listener);
			listener.apply(null, valueObjects);
		}
		
		public function execute0():void
		{
			if (once) signal.remove(listener);
			listener();
		}
		
		public function execute1(value1:Object):void
		{
			if (once) signal.remove(listener);
			listener(value1);
		}
		
		public function execute2(value1:Object, value2:Object):void
		{
			if (once) signal.remove(listener);
			listener(value1, value2);
		}		
	}
}
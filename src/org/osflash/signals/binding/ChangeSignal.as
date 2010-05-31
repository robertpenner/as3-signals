package org.osflash.signals.binding 
{
	import org.osflash.signals.Signal;

	public class ChangeSignal extends Signal implements IChangeSignal
	{
		protected var source:Object;

		public function ChangeSignal(source:Object)
		{
			super(Object, String, Object);
			this.source = source;
		}
		
		public function dispatchChange(sourceProperty:String, newValue:Object):void
		{
			dispatch(source, sourceProperty, newValue);
		}
	}
}

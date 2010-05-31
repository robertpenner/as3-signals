package org.osflash.signals.binding 
{
	import org.osflash.signals.Signal;

	public class ChangeSignal extends Signal implements IChangeSignal
	{
		protected var source:IBindable;

		public function ChangeSignal(source:IBindable)
		{
			super(IBindable, String, Object);
			this.source = source;
		}
		
		public function dispatchChange(sourceProperty:String, newValue:Object):void
		{
			dispatch(source, sourceProperty, newValue);
		}
	}
}

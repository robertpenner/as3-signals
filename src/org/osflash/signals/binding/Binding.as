package org.osflash.signals.binding 
{
	public class Binding 
	{
		public var target:Object;		public var targetProperty:String = '';
		public var source:IBindable;
		public var sourceProperty:String = '';

		public function Binding(source:IBindable, sourceProperty:String, target:Object, targetProperty:String) 
		{
			this.source = source;
			this.sourceProperty = sourceProperty;
			this.target = target;
			this.targetProperty = targetProperty;
		}
	}
}

package org.osflash.signals.binding 
{
	import flash.utils.Dictionary;

	public class Binder 
	{
		protected var bindMap:Dictionary;

		public function Binder() 
		{
			bindMap = new Dictionary(true);
		}

		
		public function bind(source:IBindable, sourceProperty:String, target:Object, targetProperty:String):void 
		{
			var binding:Binding = new Binding(source, sourceProperty, target, targetProperty);
			bindMap[source] ||= {};
			bindMap[source][sourceProperty] = binding;
			
			source.propertyChanged.add(onChanged);
		}
		
		protected function onChanged(source:IBindable, sourceProperty:String, newValue:Object):void
		{
			var binding:Binding = bindMap[source][sourceProperty];
			
			binding.target[binding.targetProperty] = newValue;
		}
	}
}

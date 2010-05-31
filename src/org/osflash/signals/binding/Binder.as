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
		
		public function bind(target:Object, targetProperty:String, source:IBindable, sourceProperty:String):void 
		{
			var binding:Binding = new Binding(source, sourceProperty, target, targetProperty);
			(bindMap[target] ||= {})[targetProperty] = binding;
			source.propertyChanged.add(binding.onChange);
		}

		public function doubleBind(target:IBindable, targetProperty:String, source:IBindable, sourceProperty:String):void 
		{
			var binding:Binding = new Binding(source, sourceProperty, target, targetProperty, true);
			(bindMap[target] ||= {})[targetProperty] = binding;
			source.propertyChanged.add(binding.onChange);
			target.propertyChanged.add(binding.onChange);
		}
		
		public function unbind(target:Object, targetProperty:String):void 
		{
			var binding:Binding = Binding( bindMap[target][targetProperty] );
			binding.source.propertyChanged.remove(binding.onChange);
		}
	}
}

package org.osflash.signals.binding 
{
	import flash.utils.Dictionary;

	public class Binder 
	{
		protected var bindMap:Dictionary;

		public function Binder(useWeakReferences:Boolean = true) 
		{
			bindMap = new Dictionary(useWeakReferences);
		}
		
		public function bind(target:Object, targetProperty:String, source:IBindable, sourceProperty:String):void 
		{
			var binding:Binding = new Binding(target, targetProperty, source, sourceProperty);
			(bindMap[target] ||= {})[targetProperty] = binding;
		}

		public function doubleBind(source1:IBindable, source1Property:String, source2:IBindable, source2Property:String):void 
		{
			bind(source1, source1Property, source2, source2Property);			bind(source2, source2Property, source1, source1Property);
		}
		
		//TODO: doubleUnbind
		
		public function unbind(target:Object, targetProperty:String):void 
		{
			var binding:Binding = Binding( bindMap[target][targetProperty] );
			binding.unbind();
			delete bindMap[target][targetProperty];
		}

		public function hasBinding(target:Object, targetProperty:String):Boolean 
		{
			return Boolean( bindMap[target] && bindMap[target][targetProperty] );
		}

		public function unbindAll():void 
		{
			for (var target:Object in bindMap)
			{
				for each (var binding:Binding in bindMap[target])
				{
					binding.unbind();
				}
				delete bindMap[target];
			}
		}
	}
}

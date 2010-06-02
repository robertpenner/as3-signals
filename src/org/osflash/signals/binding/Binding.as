package org.osflash.signals.binding 
{
	public class Binding implements IChangeSlot
	{
		public var target:Object;
		public var targetProperty:String = '';
		public var source:IBindable;
		protected var _sourceProperty:String = '';

		public function Binding(target:Object, targetProperty:String, source:IBindable, sourceProperty:String) 
		{
			this.target = target;
			this.targetProperty = targetProperty;
			this.source = source;
			this.sourceProperty = sourceProperty;
			bind();
		}
		
		public function get sourceProperty():String { return _sourceProperty; }
		
		public function set sourceProperty(value:String):void { _sourceProperty = value; }	

		public function bind():void 
		{
			// Sync immediately
			if (target[targetProperty] != source[sourceProperty])
				target[targetProperty]  = source[sourceProperty];
			// Listen for future changes
			source.propertyChanged.add(onChange);
		}

		public function unbind():void 
		{
			source.propertyChanged.remove(onChange);
		}
		
		public function onChange(fromObject:Object, property:String, newValue:Object):void
		{
			//TODO: check against old value
			//TODO: perhaps move filtering out of here
			
			if (fromObject == source && property == sourceProperty)
			{
				if (target[targetProperty] != newValue)
					target[targetProperty]  = newValue;
			}
		}
		
	}
}

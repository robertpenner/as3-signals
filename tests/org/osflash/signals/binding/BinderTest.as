package org.osflash.signals.binding 
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class BinderTest
	{
	    [Inject]
	    public var async:IAsync;
		private var source:BindableThing;
		private var target:Object;	
		private var binder:Binder;

		[Before]
		public function setUp():void
		{
			source = new BindableThing();
			target = new Object();
			binder = new Binder();
		}

		[After]
		public function tearDown():void
		{
			source = null;
			binder = null;
		}
		
		[Test]
		public function bind_and_change_source_property_should_set_target_property_to_the_same_value():void
		{
			var sourceProperty:String = 'status';
			var targetProperty:String = 'text';
			binder.bind(source, sourceProperty, target, targetProperty);
			
			var newValue:String = 'changed';
			source[sourceProperty] = newValue;
			assertEquals(newValue, target[targetProperty]);
		}
		
		
	}
}

import org.osflash.signals.binding.ChangeSignal;
import org.osflash.signals.binding.IBindable;
import org.osflash.signals.binding.IChangeSignal;

class BindableThing implements IBindable
{
	protected var _propertyChanged:ChangeSignal;
	public function get propertyChanged():IChangeSignal
	{
		return _propertyChanged ||= new ChangeSignal(this);
	}
	
	protected var _status:String = '';
	public function get status():String { return _status; }
	
	public function set status(value:String):void
	{
		_propertyChanged.dispatchChange('status', _status = value);
	}
}
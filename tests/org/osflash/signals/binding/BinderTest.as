package org.osflash.signals.binding 
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class BinderTest
	{
	    [Inject]
	    public var async:IAsync;
		private var target:Object;	
		private var source:BindableThing;
		private var binder:Binder;
		private var targetProperty:String;		private var sourceProperty:String;

		[Before]
		public function setUp():void
		{
			target = { text: 'default' };
			targetProperty = 'text';
			source = new BindableThing();
			sourceProperty = 'status';
			binder = new Binder();
		}

		[After]
		public function tearDown():void
		{
			target = null;			source = null;
			binder = null;
		}
		
		[Test]
		public function bind_can_hasBinding():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			assertTrue(binder.hasBinding(target, targetProperty));
		}
		
		[Test]
		public function didnt_bind_cant_hasBinding():void
		{
			assertFalse(binder.hasBinding(target, targetProperty));
		}
		
		[Test]
		public function bind_then_unbind_cant_hasBinding():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			binder.unbind(target, targetProperty);
			assertFalse(binder.hasBinding(target, targetProperty));
		}
		
		[Test]
		public function bind_should_update_from_source_to_target():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			
			var newValue:String = 'changed';
			// when
			source[sourceProperty] = newValue;
			// then
			assertEquals('target updated from source', newValue, target[targetProperty]);
		}
		
		[Test]
		public function unbind_should_disable_updates_from_source_to_target():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);			binder.unbind(target, targetProperty);			
			var oldValue:String = target[targetProperty];
			var newValue:String = 'changed';
			// when
			source[sourceProperty] = newValue;
			// then
			assertEquals('target unchanged', oldValue, target[targetProperty]);
		}
		
		[Test]
		public function bind_should_be_one_way_only():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			
			var oldValue:String = source[sourceProperty];
			var newValue:String = 'changed';
			// when
			target[targetProperty] = newValue;
			// then
			assertEquals('source unchanged', oldValue, source[sourceProperty]);
		}
				
		[Test]
		public function doubleBind_should_enable_updates_in_opposite_direction():void
		{
			var bindableTarget:IBindable = new BindableThing();
			binder.doubleBind(bindableTarget, targetProperty, source, sourceProperty);
			
			var newValue:String = 'changedFromOppositeEnd';
			// when
			bindableTarget[targetProperty] = newValue;
			// then
			assertEquals('source updated from target', newValue, source[sourceProperty]);			
		}
		
		[Test]
		public function doubleBind_should_enable_updates_in_normal_direction():void
		{
			var bindableTarget:IBindable = new BindableThing();
			binder.doubleBind(bindableTarget, targetProperty, source, sourceProperty);
			
			var newValue:String = 'changed';
			// when
			source[sourceProperty] = newValue;
			// then
			assertEquals('target updated from source', newValue, bindableTarget[targetProperty]);			
		}
		
		//TODO: test that updating one property calls listeners for that property only
		//TODO: test that setting a property to its existing value doesn't do extra work
		
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
		if (value == _status) return;
		_propertyChanged.dispatchChange('status', _status = value);	}
	
	protected var _text:String = 'default';
	public function get text():String { return _text; }
	
	public function set text(value:String):void
	{
		if (value == _text) return;
		_propertyChanged.dispatchChange('text', _text = value);
	}	
}
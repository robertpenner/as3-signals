package org.osflash.signals.binding 
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class BinderTest
	{
	    [Inject]
	    public var async:IAsync;
	    
		private var target:Object;	
		private var targetProperty:String;
		private var source:BindableThing;
		private var sourceProperty:String;
		private var binder:Binder;

		[Before]
		public function setUp():void
		{
			target = { text: 'defaultText' };
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
		public function bind_should_immediately_sync_target_to_source():void
		{
			var currentSourceValue:String = source[sourceProperty];
			assertNotSame('target different from source before bind', currentSourceValue, target[targetProperty]);
			// when
			binder.bind(target, targetProperty, source, sourceProperty);
			// then
			assertEquals('target synced to source', currentSourceValue, target[targetProperty]);
		}
		
		[Test]
		public function bind_should_update_from_source_to_target_on_change():void
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
		public function unbindAll_should_disable_updates_from_source_to_target():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			binder.unbindAll();
			
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
		public function doubleBind_should_immediately_sync_both_sources_to_the_second_source():void
		{
			var source2:IBindable = new BindableThing();
			var source2Property:String = 'text';
			var source2ValueBeforeBind:String = source2[source2Property];
			// when
			binder.doubleBind(source, sourceProperty, source2, source2Property);
			// then
			assertEquals('second source is same as before bind', source2ValueBeforeBind, source2[source2Property]);						assertEquals('first source is synced to second source', source2ValueBeforeBind, source[sourceProperty]);			
		}
		
		[Test]
		public function changing_an_unbound_source_property_should_not_update_bound_target_property():void
		{
			binder.bind(target, targetProperty, source, sourceProperty);
			var oldTargetValue:String = target[targetProperty];
			var unboundSourceProperty:String = 'text';			
			// when
			source[unboundSourceProperty] = 'dontMindMe';
			// then
			assertEquals('target unchanged', oldTargetValue, target[targetProperty]);			
		}
		
		//TODO: test that setting a property to its existing value doesn't do extra work
		
	}
}

import org.osflash.signals.binding.ChangeSignal;
import org.osflash.signals.binding.IBindable;
import org.osflash.signals.binding.IChangeSignal;

class BindableThing implements IBindable
{
	protected var _changeSignal:ChangeSignal;

	public function BindableThing() 
	{
		_changeSignal = new ChangeSignal(this);
	}

	public function get changeSignal():IChangeSignal
	{
		return _changeSignal;
	}
	
	protected var _status:String = 'defaultStatus';
	public function get status():String { return _status; }
	
	public function set status(value:String):void
	{
		if (value == _status) return;
		_changeSignal.dispatch('status', _status = value);	}
	
	protected var _text:String = 'defaultText';
	public function get text():String { return _text; }
	
	public function set text(value:String):void
	{
		if (value == _text) return;
		_changeSignal.dispatch('text', _text = value);
	}	
}
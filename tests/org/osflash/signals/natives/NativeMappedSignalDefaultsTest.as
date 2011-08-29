package org.osflash.signals.natives
{
	import asunit.framework.IAsync;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NativeMappedSignalDefaultsTest
	{
	    [Inject]
	    public var async:IAsync;
		
		private var signalDefault:NativeMappedSignal;
		private var signalDefaultWithMappingObject:NativeMappedSignal;
		private var signalDefaultWithMappingFunction:NativeMappedSignal;
		private var signalWithValueClassesWithoutMappingFunction:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signalDefault = new NativeMappedSignal(sprite, EventType);
			signalDefaultWithMappingObject = new NativeMappedSignal(sprite, EventType).mapTo(MappedObject);
			signalDefaultWithMappingFunction = new NativeMappedSignal(sprite, EventType).mapTo(
				function ():String {
					return MappedObject;
				}
			);
			signalWithValueClassesWithoutMappingFunction = new NativeMappedSignal(sprite, EventType, MouseEvent, String);
		}
		
		[After]
		public function tearDown():void
		{
			signalDefault.removeAll();
			signalDefault = null;
			signalDefaultWithMappingObject.removeAll();
			signalDefaultWithMappingObject = null;
			signalDefaultWithMappingFunction.removeAll();
			signalDefaultWithMappingFunction = null;
			signalWithValueClassesWithoutMappingFunction.removeAll();
			signalWithValueClassesWithoutMappingFunction = null;
		}
		
		//////
		[Test]
		public function signal_default_add_then_emptyCallback_should_be_called():void
		{
			signalDefault.add( async.add(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function emptyCallback(e:* = null):void {}
		
		[Test]
		public function signal_default_with_mapped_object_add_then_emptyCallback_should_be_called():void
		{
			signalDefaultWithMappingObject.add( async.add(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		[Test]
		public function signal_default_with_mapped_function_add_then_emptyCallback_should_be_called():void
		{
			signalDefaultWithMappingFunction.add( async.add(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		[Test(expects="ArgumentError")]
		public function signal_with_value_classes_without_mapping_function():void
		{
			signalWithValueClassesWithoutMappingFunction.dispatch(new MouseEvent(EventType));
		}
	}
}

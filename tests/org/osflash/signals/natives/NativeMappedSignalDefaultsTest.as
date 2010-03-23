package org.osflash.signals.natives
{
	import asunit.asserts.*;
	
	import asunit4.async.addAsync;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.ISignal;
	
	public class NativeMappedSignalDefaultsTest
	{
		private var signalDefault:NativeMappedSignal;
		private var signalDefaultWithMappingObject:NativeMappedSignal;
		private var signalDefaultWithMappingFunction:NativeMappedSignal;
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
		}
		
		[After]
		public function tearDown():void
		{
			signalDefault.removeAll();
			signalDefault = null;
			signalDefaultWithMappingObject.removeAll()
			signalDefaultWithMappingObject = null
			signalDefaultWithMappingFunction.removeAll()
			signalDefaultWithMappingFunction = null
		}
		
		public function testInstantiated():void
		{
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			
			assertTrue("NativeMappedSignal instantiated", signalDefault is NativeMappedSignal);
			assertTrue('implements ISignal', signalDefault is ISignal);
			assertSame('has only one value class', 1, signalDefault.valueClasses.length);
			assertSame('single value class is of type String', String, signalDefault.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalDefaultWithMappingObject is NativeMappedSignal);
			assertTrue('implements ISignal', signalDefaultWithMappingObject is ISignal);
			assertSame('has only one value class', 1, signalDefaultWithMappingObject.valueClasses.length);
			assertSame('single value class is of type String', String, signalDefaultWithMappingObject.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalDefaultWithMappingFunction is NativeMappedSignal);
			assertTrue('implements ISignal', signalDefaultWithMappingFunction is ISignal);
			assertSame('has only one value class', 1, signalDefaultWithMappingFunction.valueClasses.length);
			assertSame('single value class is of type String', signalDefaultWithMappingFunction, signalDefault.valueClasses[0]);
		}
		//////
		[Test]
		public function signal_default_add_then_emptyCallback_should_be_called():void
		{
			signalDefault.add( addAsync(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function emptyCallback():void {}
		
		[Test]
		public function signal_default_with_mapped_object_add_then_emptyCallback_should_be_called():void
		{
			signalDefaultWithMappingObject.add( addAsync(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		[Test]
		public function signal_default_with_mapped_function_add_then_emptyCallback_should_be_called():void
		{
			signalDefaultWithMappingFunction.add( addAsync(emptyCallback, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
	}		
}
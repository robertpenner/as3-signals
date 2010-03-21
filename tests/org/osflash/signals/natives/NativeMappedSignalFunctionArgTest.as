package org.osflash.signals.natives
{
	import asunit.asserts.*;
	
	import asunit4.async.addAsync;
	
	import org.osflash.signals.ISignal;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class NativeMappedSignalFunctionArgTest
	{
		private var clicked:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeMappedSignal(sprite, EventType, String, function ():String {
				return MappedObject
			});
		}
		
		[After]
		public function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}
		
		public function testInstantiated():void
		{
			assertTrue("NativeMappedSignal instantiated", clicked is NativeMappedSignal);
			assertTrue('implements ISignal', clicked is ISignal);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			assertSame('has only one value class', 1, clicked.valueClasses.length);
			assertSame('single value class is of type String', String, clicked.valueClasses[0]);
		}
		//////
		[Test]
		public function signal_add_then_mapped_object_should_be_callback_argument():void
		{
			clicked.add( addAsync(checkMappedArgument, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function checkMappedArgument(argument:String):void
		{
			assertSame(MappedObject, argument);
		}
		//////
		[Test]
		public function mapping_function_should_receive_event_as_argument():void
		{
			clicked = new NativeMappedSignal(sprite, EventType, String, checkMappingFunctionArguments);
			clicked.add( addAsync(checkMappedArgument, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function checkMappingFunctionArguments(event:MouseEvent):String {
			return MappedObject
		}
	}		
}
package org.osflash.signals.natives
{
	import asunit.asserts.*;
	
	import asunit4.async.addAsync;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.ISignal;
	
	public class NativeMappedSignalFunctionArgTest
	{
		private var signal:NativeMappedSignal;
		private var signalMappingToEventType:NativeMappedSignal;
		private var signalMappingToIncorrectEventType:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signal = new NativeMappedSignal(sprite, EventType, String, 
				function ():String {
					return MappedObject
				}
			);
			
			signalMappingToEventType = new NativeMappedSignal(sprite, EventType, String, 
				function (event:MouseEvent):String {
					return event.type;
				}
			);
			
			signalMappingToIncorrectEventType = new NativeMappedSignal(sprite, EventType, String,
				function (event:MouseEvent):int {
					return event.delta
				}
			);
		}
		
		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
		}
		
		public function testInstantiated():void
		{
			assertTrue("NativeMappedSignal instantiated", signal is NativeMappedSignal);
			assertTrue('implements ISignal', signal is ISignal);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			assertSame('has only one value class', 1, signal.valueClasses.length);
			assertSame('single value class is of type String', String, signal.valueClasses[0]);
			assertSame('has only one value class', 1, signalMappingToEventType.valueClasses.length);
			assertSame('single value class is of type String', String, signalMappingToEventType.valueClasses[0]);
			assertSame('has only one value class', 1, signalMappingToIncorrectEventType.valueClasses.length);
			assertSame('single value class is of type String', String, signalMappingToIncorrectEventType.valueClasses[0]);
		}
		
		private function dispatchTestEvent():void
		{
			sprite.dispatchEvent(buildTestEvent());
		}
		
		private function buildTestEvent():Event
		{
			return new MouseEvent(EventType);
		}
		
		//////
		[Test]
		public function signal_add_then_mapped_object_should_be_callback_argument():void
		{
			signal.add( addAsync(checkMappedArgument, 10) );
			dispatchTestEvent();
		}
		
		private function checkMappedArgument(argument:String):void
		{
			assertSame(MappedObject, argument);
		}
		//////
		[Test]
		public function mapping_function_should_receive_event_as_argument():void
		{
			signalMappingToEventType.add( addAsync(checkMappedEventTypeArgument, 10) );
			dispatchTestEvent();
		}
		
		private function checkMappedEventTypeArgument(argument:String):void
		{
			assertSame(EventType, argument);
		}
		
		[Test(expects="ArgumentError")]
		public function mapping_function_has_to_many_arguments_should_throw_ArgumentError():void
		{
			var signal:NativeMappedSignal = new NativeMappedSignal(sprite, EventType, String, 
				function (event:MouseEvent, extraArg:Object):String {
					return event.type;
				}
			);
			dispatchTestEvent();
		}
		
		[Test(expects="Error")]
		public function mapping_function_returns_incorrectly_typed_argument_should_throw_Error():void
		{
			signalMappingToIncorrectEventType.dispatch(buildTestEvent());
		}
		
		[Test(expects="ArgumentError")]
		public function dispatching_non_event_should_throw_ArgumentError():void
		{
			signal.dispatch("non-event argument");
		}
		
		private function emptyHandler(argument:String):void {}
	}		
}
package org.osflash.signals.natives
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.IPrioritySignal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NativeMappedSignalFunctionArgTest
	{
	    [Inject]
	    public var async:IAsync;
		
		private var signal:NativeMappedSignal;
		private var signalMappingToEventType:NativeMappedSignal;
		private var signalMappingToIncorrectEventType:NativeMappedSignal;
		private var signalMappingToVoid:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signal = new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(
				function ():String {
					return MappedObject;
				}
			);
			
			signalMappingToEventType = new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(
				function (event:MouseEvent):String {
					return event.type;
				}
			);
			
			signalMappingToIncorrectEventType = new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(
				function (event:MouseEvent):int {
					return event.delta;
				}
			);
			
			signalMappingToVoid = new NativeMappedSignal(sprite, EventType).mapTo(function ():void {});
		}
		
		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
			signalMappingToEventType.removeAll();
			signalMappingToEventType = null;
			signalMappingToIncorrectEventType.removeAll();
			signalMappingToIncorrectEventType = null;
			signalMappingToVoid.removeAll();
			signalMappingToVoid = null;
		}
		
		[Test]
		public function testInstantiated():void
		{
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			
			assertTrue("NativeMappedSignal instantiated", signal is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signal is IPrioritySignal);
			assertSame('has only one value class', 1, signal.valueClasses.length);
			assertSame('single value class is of type String', String, signal.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalMappingToEventType is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalMappingToEventType is IPrioritySignal);
			assertSame('has only one value class', 1, signalMappingToEventType.valueClasses.length);
			assertSame('single value class is of type String', String, signalMappingToEventType.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalMappingToIncorrectEventType is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalMappingToIncorrectEventType is IPrioritySignal);
			assertSame('has only one value class', 1, signalMappingToIncorrectEventType.valueClasses.length);
			assertSame('single value class is of type String', String, signalMappingToIncorrectEventType.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalMappingToVoid is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalMappingToVoid is IPrioritySignal);
			assertSame('has no value classes', 0, signalMappingToVoid.valueClasses.length);
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
			signal.add( async.add(checkMappedArgument, 10) );
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
			signalMappingToEventType.add( async.add(checkMappedEventTypeArgument, 10) );
			dispatchTestEvent();
		}
		
		private function checkMappedEventTypeArgument(argument:String):void
		{
			assertSame(EventType, argument);
		}
		
		[Test(expects="ArgumentError")]
		public function mapping_function_has_to_many_arguments_should_throw_ArgumentError():void
		{
			new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(
				function (event:MouseEvent, extraArg:Object):String {
					return event.type;
				}
			);
		}
		
		[Test(expects="Error")]
		public function mapping_function_returns_incorrectly_typed_argument_should_throw_Error():void
		{
			signalMappingToIncorrectEventType.dispatch(buildTestEvent());
		}
		
		private function emptyHandler(argument:String):void {}
		
		[Test]
		public function mapping_to_void():void
		{
			signalMappingToVoid.add(async.add(emptyHandler, 10));
			dispatchTestEvent();
		}
	}
}

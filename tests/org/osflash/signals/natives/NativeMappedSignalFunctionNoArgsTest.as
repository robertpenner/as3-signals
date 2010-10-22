package org.osflash.signals.natives
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.IPrioritySignal;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NativeMappedSignalFunctionNoArgsTest
	{
	    [Inject]
	    public var async:IAsync;
		
		private var signalSingle:NativeMappedSignal;
		private var signalList:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		private const MappedObject2:int = 3;
		private const MappedObject3:Number = 3.1415;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signalSingle = new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(
				function ():String {
					return MappedObject;
				}
			);
			
			signalList = new NativeMappedSignal(sprite, EventType, MouseEvent, String, int, Number).mapTo(
				function ():Array
				{
					return [MappedObject, MappedObject2, MappedObject3];
				}
			);
		}
		
		[After]
		public function tearDown():void
		{
			signalSingle.removeAll();
			signalSingle = null;
			signalList.removeAll();
			signalList = null;
		}
		
		[Test]
		public function testInstantiated():void
		{
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			
			assertTrue("NativeMappedSignal instantiated", signalSingle is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalSingle is IPrioritySignal);
			assertSame('has only one value class', 1, signalSingle.valueClasses.length);
			assertSame('single value class is of type String', String, signalSingle.valueClasses[0]);
			
			assertTrue("NativeMappedSignal instantiated", signalList is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalList is IPrioritySignal);
			assertSame('has three value classes', 3, signalList.valueClasses.length);
			assertSame('first value class is of type String', String, signalList.valueClasses[0]);
			assertSame('second value class is of type int', int, signalList.valueClasses[1]);
			assertSame('third value class is of type Number', Number, signalList.valueClasses[2]);
		}
		//////
		[Test]
		public function signal_add_then_mapped_object_should_be_callback_argument():void
		{
			signalSingle.add( async.add(checkMappedArgumentSingle, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function checkMappedArgumentSingle(argument:String):void
		{
			assertSame(MappedObject, argument);
		}
		//////
		[Test]
		public function signal_list_add_then_mapped_object_should_be_callback_argument():void
		{
			signalList.add( async.add(checkMappedArgumentList, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function checkMappedArgumentList(argument1:String, argument2:int, argument3:Number):void
		{
			assertSame(MappedObject, argument1);
			assertSame(MappedObject2, argument2);
			assertSame(MappedObject3, argument3);
		}
	}
}

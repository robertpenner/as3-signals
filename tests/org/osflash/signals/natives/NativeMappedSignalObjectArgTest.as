package org.osflash.signals.natives
{
	import asunit.asserts.*;
	
	import asunit4.async.addAsync;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.ISignal;
	
	public class NativeMappedSignalObjectArgTest
	{
		private var signal:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const MappedObject:String = "mapped " + EventType;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signal = new NativeMappedSignal(sprite, EventType, MouseEvent, String).mapTo(MappedObject)
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
		}
		//////
		[Test]
		public function signal_add_then_mapped_object_should_be_callback_argument():void
		{
			signal.add( addAsync(checkMappedArgument, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function checkMappedArgument(argument:String):void
		{
			assertSame(MappedObject, argument);
		}
	}		
}
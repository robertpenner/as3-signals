package org.osflash.signals.natives
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.IPrioritySignal;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NativeMappedSignalBoundaryUseTest
	{
	    [Inject]
	    public var async:IAsync;
		
		private var signalArrayOfFunctions:NativeMappedSignal;
		private var signalPassArray:NativeMappedSignal;
		private var signalPassArrayThroughFunction:NativeMappedSignal;
		private var sprite:Sprite;
		private const EventType:String = MouseEvent.CLICK;
		private const func1:Function = function ():String { return 'mapped arg 1'; };
		private const func2:Function = function ():String { return 'mapped arg 2'; };
		private const MappedArray:Array = [0, 1];
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signalArrayOfFunctions = new NativeMappedSignal(sprite, EventType).mapTo(func1, func2);
			signalPassArray = new NativeMappedSignal(sprite, EventType).mapTo(MappedArray);
			signalPassArrayThroughFunction = new NativeMappedSignal(sprite, EventType, MouseEvent, Array).mapTo(
				function ():Array {
					return MappedArray;
				}
			);
		}
		
		[After]
		public function tearDown():void
		{
			signalArrayOfFunctions.removeAll();
			signalArrayOfFunctions = null;
			signalPassArray.removeAll();
			signalPassArray = null;
			signalPassArrayThroughFunction.removeAll();
			signalPassArrayThroughFunction = null;
		}
		
		[Test]
		public function testInstantiated():void
		{
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener(EventType));
			
			assertTrue("NativeMappedSignal instantiated", signalArrayOfFunctions is NativeMappedSignal);
			assertTrue('implements ISignal', signalArrayOfFunctions is IPrioritySignal);
			assertSame('has no value classes', 0, signalArrayOfFunctions.valueClasses.length);
			
			assertTrue("NativeMappedSignal instantiated", signalPassArray is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalPassArray is IPrioritySignal);
			assertSame('has no value classed', 0, signalPassArray.valueClasses.length);
			
			assertTrue("NativeMappedSignal instantiated", signalPassArrayThroughFunction is NativeMappedSignal);
			assertTrue('implements IPrioritySignal', signalPassArrayThroughFunction is IPrioritySignal);
			assertSame('has only one value class', 1, signalPassArrayThroughFunction.valueClasses.length);
			assertSame('single value class is of type Array', Array, signalPassArrayThroughFunction.valueClasses[0]);
		}
		//////
		[Test]
		public function signal_array_of_functions_add_then_callback_called():void
		{
			signalArrayOfFunctions.add( async.add(callbackTwoFunctions, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function callbackTwoFunctions(argFunc1:Function, argFunc2:Function):void
		{
			assertSame(func1, argFunc1);
			assertSame(func2, argFunc2);
		}
		
		[Test]
		public function signal_pass_array_add_then_array_callback_should_be_called():void
		{
			signalPassArray.add( async.add(callbackArrayAsArg, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
		
		private function callbackArrayAsArg(argArray:Array):void
		{
			assertSame(MappedArray, argArray);
		}
		
		[Test]
		public function signal_pass_array_through_function_add_then_array_callback_should_be_called():void
		{
			signalPassArrayThroughFunction.add( async.add(callbackArrayAsArg, 10) );
			sprite.dispatchEvent(new MouseEvent(EventType));
		}
	}
}

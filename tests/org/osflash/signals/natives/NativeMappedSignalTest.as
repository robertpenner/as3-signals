package org.osflash.signals.natives
{
	import asunit.asserts.*;
	
	import asunit4.async.addAsync;
	
	import org.osflash.signals.ISignal;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class NativeMappedSignalTest
	{
		private var clicked:NativeMappedSignal;
		private var sprite:Sprite;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeMappedSignal(sprite, 'click', 'mapped click');
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
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
		}
		//////
		[Test]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( addAsync(checkMappedArgument, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function checkMappedArgument(argument:String):void
		{
			assertSame("mapped click", argument);
		}
	}		
}
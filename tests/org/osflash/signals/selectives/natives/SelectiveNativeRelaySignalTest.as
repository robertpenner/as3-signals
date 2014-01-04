package org.osflash.signals.selectives.natives {

	import asunit.asserts.*;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	import org.osflash.signals.selectives.ISelectiveSignalTestBase;
	
	/**
	 * Tests for SelectiveNativeRelaySignal
	 */
	public class SelectiveNativeRelaySignalTest extends ISelectiveSignalTestBase {
		
		protected var sprite:Sprite = new Sprite();
		
		/**
		 * Default selective native relay signal used in the tests below
		 */
		[Before]
		public function setUp():void {
			selective = new SelectiveNativeRelaySignal(sprite, KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):uint {
				return event.keyCode;
			}, KeyboardEvent);
		}
		
		/**
		 * Using a faulty provider - a non-Function value - should result in an ArgumentError
		 */
		[Test(expects='ArgumentError')]
		public function faulty_provider():void {
			selective = new SelectiveNativeRelaySignal(sprite, KeyboardEvent.KEY_DOWN, null, KeyboardEvent);
		}
		
		/**
		 * Ensure provider is correctly assigned through constructor
		 */
		[Test]
		public function provider_through_constructor():void {
			var provider:Function = function():void { };
			selective = new SelectiveNativeRelaySignal(sprite, KeyboardEvent.KEY_DOWN, provider, KeyboardEvent);
			assertSame(selective.provider, provider);
		}
		
		/**
		 * Tests selective dispatching
		 */
		[Test]
		public function selective_dispatching():void {
			
			// Counter and listener for all keyboard events
			var all:uint = 0;
			selective.add(function(event:KeyboardEvent):void {
				all++;
			});
			
			// Counter and listener for 'A'-key keyboard events only
			var a:uint = 0; 
			selective.addFor(65, function(event:KeyboardEvent):void {
				assertEquals(event.keyCode, 65);
				a++;
			});
			
			// Dispatch keyboard events with different keyCodes on the sprite
			sprite.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, 66));
			sprite.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, 65));
			sprite.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, 65));
			sprite.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, 66));
			
			assertEquals(all, 4);
			assertEquals(a, 2);
		}
		
	}
	
}

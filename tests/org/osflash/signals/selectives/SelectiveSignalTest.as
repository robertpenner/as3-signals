package org.osflash.signals.selectives {

	import asunit.asserts.*;
	
	import flash.events.Event;

	/**
	 * Tests for SelectiveSignal
	 */
	public class SelectiveSignalTest extends ISelectiveSignalTestBase {
		
		/**
		 * Default selective signal used in the tests below
		 */
		[Before]
		public function setUp():void {
			selective = new SelectiveSignal(function(event:Event):String {
				return event.type;
			});
		}
		
		/**
		 * Using a faulty provider - a non-Function value - should result in an ArgumentError
		 */
		[Test(expects='ArgumentError')]
		public function faulty_provider():void {
			selective = new SelectiveSignal(null);
		}
		
		/**
		 * Ensure provider is correctly assigned through constructor
		 */
		[Test]
		public function provider_through_constructor():void {
			var provider:Function = function():void { };
			selective = new SelectiveSignal(provider);
			assertSame(selective.provider, provider);
		}
		
		/**
		 * Tests selective dispatching
		 */
		[Test]
		public function selective_dispatching():void {
			
			// Counter and listener for all events
			var all:uint = 0;
			selective.add(function(event:Event):void {
				all++;
			});
			
			// Counter and listener for 'LOGIN'-events only
			var login:uint = 0; 
			selective.addFor('LOGIN', function(event:Event):void {
				assertEquals(event.type, 'LOGIN');
				login++;
			});
			
			// Dispatch events with different types
			selective.dispatch(new Event('*'));
			selective.dispatch(new Event('LOGIN'));
			selective.dispatch(new Event('ADDED'));
			selective.dispatch(new Event('LOGIN'));
			
			assertEquals(all, 4);
			assertEquals(login, 2);
		}
		
		/**
		 * Tests selective dispatching while modifying the provider
		 */
		[Test]
		public function selective_dispatching_modify_provider():void {
			
			// Provider which provides event-type length instead
			var provider:Function = function(event:Event):uint {
				return event.type.length;
			};
			
			// Listen for the 'CHANGE_PROVIDER'-event
			selective.addFor('CHANGE_PROVIDER', function(event:Event):void {
				
				// .. and change provider to the one defined above
				selective.provider = provider;
			});
			
			// Dispatch event
			selective.dispatch(new Event('CHANGE_PROVIDER'));
			assertSame(selective.provider, provider);
			
			// Create an event
			var four:Event = new Event('FOUR');
			var received:Event = null;
			
			// Listen specifically for events of type-length four (such as the one above)
			selective.addFor(4, function(event:Event):void {
				received = event;
			});
			selective.dispatch(four);
			
			assertSame(four, received);
		}
		
	}
	
}

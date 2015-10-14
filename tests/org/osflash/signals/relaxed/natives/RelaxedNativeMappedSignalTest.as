package org.osflash.signals.relaxed.natives
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertTrue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class RelaxedNativeMappedSignalTest
	{
		
		static private const FOO : String = "foo";
		
		public function RelaxedNativeMappedSignalTest()
		{
		}
		
		private var _signal : RelaxedNativeMappedSignal; 
		private var _dispatcher : EventDispatcher;
		
		[Before]
		public function setUp():void
		{
			_dispatcher = new EventDispatcher();
			_signal = new RelaxedNativeMappedSignal( _dispatcher, Event.COMPLETE, Event, String )
			_signal.mapTo( FOO );
		}
		
		[After]
		public function tearDown():void{
			_signal = null;
		}
		
		[Test]
		public function testRelaxedDispatchingToOnceAddedListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.addOnce( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToOnceAddedWitPriorityListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.addOnceWithPriority( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToAddedListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.add( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToAddedWithPriorityListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.addWithPriority( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testListenerDoesntExistAfterAddedOnce():void{
			var handler : Function = function():void{
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.addOnce( handler );
			assertEquals( 'should have no listeners', 0, _signal.numListeners );
		}
		
		[Test]
		public function testListenerExistsAfterAdded():void{
			var handler : Function = function():void{
			}
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			_signal.add( handler );
			assertEquals( 'should have exactly one listener', 1, _signal.numListeners );
		}
		
		[Test]
		public function testEventIsPassed():void{
			var event : Event =  new Event( Event.COMPLETE );
			var passedPayload : String;
			var handler : Function =function( payload : String ) : void{
				passedPayload = payload;
			}
			_dispatcher.dispatchEvent( event );
			_signal.addOnce( handler );
			assertEquals( 'should match', FOO, passedPayload );
		}
		
		
		[Test]
		public function testStandardDispatchingStillWorks():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.addOnce( handler );
			_dispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testDirectDispatch():void{
			var event : Event =  new Event( Event.COMPLETE );
			var passedPayload : String;
			var handler : Function =function( payload : String ) : void{
				passedPayload = payload;
			}
			_signal.dispatch( event );
			_signal.addOnce( handler );
			assertEquals( 'should match', FOO, passedPayload );
		}	
	}
}
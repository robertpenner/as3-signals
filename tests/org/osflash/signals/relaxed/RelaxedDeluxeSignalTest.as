package org.osflash.signals.relaxed
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertTrue;
	
	import org.osflash.signals.IOnceSignal;
	import org.osflash.signals.relaxed.support.RelaxedSignalTestVO;

	public class RelaxedDeluxeSignalTest
	{
		public function RelaxedDeluxeSignalTest()
		{
		}
		private var _signal : RelaxedDeluxeSignal; 
		
		[Before]
		public function setUp():void
		{
			_signal = new RelaxedDeluxeSignal();
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
			_signal.dispatch();
			_signal.addOnce( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToOnceAddedWitPriorityListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.dispatch();
			_signal.addOnceWithPriority( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToAddedListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.dispatch();
			_signal.add( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testRelaxedDispatchingToAddedWithPriorityListener():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.dispatch();
			_signal.addWithPriority( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testListenerDoesntExistAfterAddedOnce():void{
			var handler : Function = function():void{
			}
			_signal.dispatch();
			_signal.addOnce( handler );
			assertEquals( 'should have no listeners', 0, _signal.numListeners );
		}
		
		[Test]
		public function testListenerExistsAfterAdded():void{
			var handler : Function = function():void{
			}
			_signal.dispatch();
			_signal.add( handler );
			assertEquals( 'should have exactly one listener', 1, _signal.numListeners );
		}
		
		[Test]
		public function testSingleVO():void{
			var value : String = 'foo';
			var passedPayload : String;
			var handler : Function =function( payload : String ) : void{
				passedPayload = payload;
			}
			_signal.dispatch( value );
			_signal.addOnce( handler );
			assertEquals( 'should match', value, passedPayload );
		}
		
		[Test]
		public function testMultipleVOs():void{
			var value1 : String = 'foo';
			var value2 : String = 'bar';
			var passedPayload1 : String;
			var passedPayload2 : String;
			var handler : Function =function( payload1 : String, payload2 : String ) : void{
				passedPayload1 = payload1;
				passedPayload2 = payload2;
			}
			_signal.dispatch( value1, value2 );
			_signal.addOnce( handler );
			assertTrue( passedPayload1 == value1 && passedPayload2 == value2 );
		}
		
		[Test]
		public function testArrayAsPayload():void{
			var value : Array = [ 'a', 'b', 'c' ];
			var passedPayload : Array;
			var handler : Function =function( payload : Array ) : void{
				passedPayload = payload;
			}
			_signal.dispatch( value );
			_signal.addOnce( handler );
			assertEquals( 'should match', value, passedPayload );
		}
		
		[Test]
		public function testStandardDispatchingStillWorks():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.addOnce( handler );
			_signal.dispatch();
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testStrictPayload():void{
			var value : RelaxedSignalTestVO = new RelaxedSignalTestVO();
			var passedPayload : RelaxedSignalTestVO;
			var handler : Function =function( payload : RelaxedSignalTestVO ) : void{
				passedPayload = payload;
			}
			_signal= new RelaxedDeluxeSignal( this, RelaxedSignalTestVO );
			_signal.dispatch( value );
			_signal.addOnce( handler );
			assertEquals( 'should match', value, passedPayload );
		}
			
	}
}
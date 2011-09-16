package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertTrue;
	import org.osflash.signals.relaxed.RelaxedOnceSignal;

	/**
	 * @author Camille Reynders - info@creynders.be
	 */
	
	public class RelaxedOnceSignalTest
	{
		public function RelaxedOnceSignalTest()
		{
		}
		
		private var _signal : IOnceSignal; 
		
		[Before]
		public function setUp():void
		{
			_signal = new RelaxedOnceSignal();
		}
		
		[After]
		public function tearDown():void{
			_signal = null;
		}
		
		[Test]
		public function testRelaxedDispatching():void{
			var handlerExecuted : Boolean = false;
			var handler : Function = function() : void{
				handlerExecuted = true;
			}
			_signal.dispatch();
			_signal.addOnce( handler );
			assertTrue( handlerExecuted );
		}
		
		[Test]
		public function testListenerDoesntExist():void{
			var handler : Function = function():void{
			}
			_signal.dispatch();
			_signal.addOnce( handler );
			assertEquals( 'should have no listeners', 0, _signal.numListeners );
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
			var value : Array = [ 'a', 'b', 'c' ];
			var handlerExecuted : Boolean = false;
			var handler : Function =function( payload : Array ) : void{
				handlerExecuted = true;
			}
			_signal = new RelaxedOnceSignal( Array );
			_signal.dispatch( value );
			_signal.addOnce( handler );
			assertTrue( handlerExecuted );
		}
		
	}
}
package org.osflash.signals
{
	import asunit.asserts.assertEqualsArrays;
	import asunit.asserts.assertEquals;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalDispatchVarArgsTest
	{
		public var signal:ISignal;

		[Before]
		public function setUp():void
		{
			signal = new Signal(int, int, int, int);
		}

		[After]
		public function tearDown():void
		{
			signal.removeAll();
			signal = null;
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_0_should_not_throw_error():void
		{
			signal.add(handlerArgsAt0());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_1_should_not_throw_error():void
		{
			signal.add(handlerArgsAt1());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_2_should_not_throw_error():void
		{
			signal.add(handlerArgsAt2());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_0_then_dispatch_should_not_throw_error():void
		{
			signal.add(handlerArgsAt0());
			signal.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_1_then_dispatch_should_not_throw_error():void
		{
			signal.add(handlerArgsAt1());
			signal.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_2_then_dispatch_should_not_throw_error():void
		{
			signal.add(handlerArgsAt2());
			signal.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function verify_num_args_after_dispatch():void
		{
			signal.add(verifyNumArgs);
			signal.dispatch(0, 1, 2, 3);
		}
		
		/////
		
		[Test]
		public function verify_redispatch_of_signal():void
		{
			const redispatch:Signal = new Signal();
			redispatch.add(handlerArgsAt0());
			
			signal.add(redispatch.dispatch);
			signal.dispatch(0, 1, 2, 3);
		}
				
		private function handlerArgsAt0():Function
		{
			return function(...args):void 
			{
				assertEqualsArrays('Arguments should be [0,1,2,3]', [0,1,2,3], args);
				assertEquals('Number of var arguments should be 4', 4, args.length);
			};
		}
		
		private function handlerArgsAt1():Function
		{
			return function(a:int, ...args):void 
			{
				assertEqualsArrays('Arguments should be [1,2,3]', [1,2,3], args);
				assertEquals('Number of var arguments should be 3', 3, args.length);
			};
		}
		
		private function handlerArgsAt2():Function
		{
			return function(a:int, b:int, ...args):void 
			{
				assertEqualsArrays('Arguments should be [2,3]', [2,3], args);
				assertEquals('Number of var arguments should be 2', 2, args.length);
			};
		}
		
		private function verifyNumArgs(...args):void
		{
			assertEquals('Number of arguments should be 4', 4, args.length);
		}
	}
}

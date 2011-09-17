package org.osflash.signals
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertEqualsArrays;
	import asunit.framework.IAsync;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class MonoSignalDispatchVarArgsTest
	{
		
		[Inject]
	    public var async:IAsync;
	
		public var completed:MonoSignal;

		[Before]
		public function setUp():void
		{
			completed = new MonoSignal(int, int, int, int);
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_0_should_not_throw_error():void
		{
			completed.add(handlerArgsAt0());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_1_should_not_throw_error():void
		{
			completed.add(handlerArgsAt1());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_2_should_not_throw_error():void
		{
			completed.add(handlerArgsAt2());
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_0_then_dispatch_should_not_throw_error():void
		{
			completed.add(handlerArgsAt0());
			completed.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_1_then_dispatch_should_not_throw_error():void
		{
			completed.add(handlerArgsAt1());
			completed.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function adding_vararg_at_2_then_dispatch_should_not_throw_error():void
		{
			completed.add(handlerArgsAt2());
			completed.dispatch(0, 1, 2, 3);
		}
		
		//////
		
		[Test]
		public function verify_num_args_after_dispatch():void
		{
			completed.add(verifyNumArgs);
			completed.dispatch(0, 1, 2, 3);
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

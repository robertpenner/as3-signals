package org.osflash.signals
{
	import asunit.asserts.assertEquals;

	public class PrioritySignalTest extends ISignalTestBase
	{

		private var prioritySignal:IPrioritySignal;

		private var gotListenerDispatchOrder:Array;

		[Before]
		public function setUp():void
		{
			gotListenerDispatchOrder = [];
			prioritySignal = new PrioritySignal();
			signal = prioritySignal;
		}

		[After]
		override public function destroySignal():void
		{
			gotListenerDispatchOrder = null;
			prioritySignal.removeAll();
			prioritySignal = null;
			signal = null;
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_1():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, 3);
			prioritySignal.addWithPriority(listenerB, 2);
			prioritySignal.addWithPriority(listenerC, 1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_2():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, 3);
			prioritySignal.addWithPriority(listenerC, 1);
			prioritySignal.addWithPriority(listenerB, 2);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_3():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, 2);
			prioritySignal.addWithPriority(listenerA, 3);
			prioritySignal.addWithPriority(listenerC, 1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_4():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, 2);
			prioritySignal.addWithPriority(listenerC, 1);
			prioritySignal.addWithPriority(listenerA, 3);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_5():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, 1);
			prioritySignal.addWithPriority(listenerA, 3);
			prioritySignal.addWithPriority(listenerB, 2);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_6():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, 1);
			prioritySignal.addWithPriority(listenerB, 2);
			prioritySignal.addWithPriority(listenerA, 3);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_1():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, 20);
			prioritySignal.addWithPriority(listenerB, 10);
			prioritySignal.addWithPriority(listenerC, 5);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_2():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, 20);
			prioritySignal.addWithPriority(listenerC, 5);
			prioritySignal.addWithPriority(listenerB, 10);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_3():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, 10);
			prioritySignal.addWithPriority(listenerA, 20);
			prioritySignal.addWithPriority(listenerC, 5);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_4():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, 10);
			prioritySignal.addWithPriority(listenerC, 5);
			prioritySignal.addWithPriority(listenerA, 20);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_5():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, 5);
			prioritySignal.addWithPriority(listenerA, 20);
			prioritySignal.addWithPriority(listenerB, 10);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_unconsecutive_6():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, 5);
			prioritySignal.addWithPriority(listenerB, 10);
			prioritySignal.addWithPriority(listenerA, 20);
			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_1():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, -1);
			prioritySignal.addWithPriority(listenerB, -2);
			prioritySignal.addWithPriority(listenerC, -3);
			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_2():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, -1);
			prioritySignal.addWithPriority(listenerC, -3);
			prioritySignal.addWithPriority(listenerB, -2);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_3():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, -2);
			prioritySignal.addWithPriority(listenerA, -1);
			prioritySignal.addWithPriority(listenerC, -3);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_4():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerB, -2);
			prioritySignal.addWithPriority(listenerC, -3);
			prioritySignal.addWithPriority(listenerA, -1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_5():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, -3);
			prioritySignal.addWithPriority(listenerA, -1);
			prioritySignal.addWithPriority(listenerB, -2);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_higher_priority_should_be_called_first_independant_of_order_added_even_if_negative_6():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, -3);
			prioritySignal.addWithPriority(listenerB, -2);
			prioritySignal.addWithPriority(listenerA, -1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_same_priority_should_be_called_in_order_added_1():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerA, 1);
			prioritySignal.addWithPriority(listenerB, 1);
			prioritySignal.addWithPriority(listenerC, 1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_same_priority_should_be_called_in_order_added_2():void
		{
			const expectedListenerDispatchOrder:Array = [B, A, C];

			prioritySignal.addWithPriority(listenerB, 1);
			prioritySignal.addWithPriority(listenerA, 1);
			prioritySignal.addWithPriority(listenerC, 1);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_priority_zero_should_be_called_in_order_added_1():void
		{
			const expectedListenerDispatchOrder:Array = [B, C, A];

			prioritySignal.add(listenerB);
			prioritySignal.add(listenerC);
			prioritySignal.add(listenerA);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_priority_zero_should_be_called_in_order_added_2():void
		{
			const expectedListenerDispatchOrder:Array = [C, B, A];

			prioritySignal.add(listenerC);
			prioritySignal.add(listenerB);
			prioritySignal.add(listenerA);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_priority_zero_should_be_called_after_high_and_before_negative_1():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, -10);
			prioritySignal.add(listenerB);
			prioritySignal.addWithPriority(listenerA, 10);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}

		[Test]
		public function listeners_added_with_priority_zero_should_be_called_after_high_and_before_negative_2():void
		{
			const expectedListenerDispatchOrder:Array = [A, B, C];

			prioritySignal.addWithPriority(listenerC, -10);
			prioritySignal.addWithPriority(listenerA, 10);
			prioritySignal.add(listenerB);

			prioritySignal.dispatch();

			assertArrayEqual(expectedListenerDispatchOrder, gotListenerDispatchOrder);
		}		

		private function listenerA():void
		{
			gotListenerDispatchOrder.push(A);
		}

		private function listenerB():void
		{
			gotListenerDispatchOrder.push(B);
		}

		private function listenerC():void
		{
			gotListenerDispatchOrder.push(C);
		}

		private function assertArrayEqual(expected:Array, got:Array):void
		{
			assertEquals("array length unequal", expected.length, got.length);
			for ( var i:int = 0; i < gotListenerDispatchOrder.length; i++ )
			{
				assertEquals("@i=" + i, expected[i], got[i]);
			}
		}

		private static const A:String = "A";

		private static const B:String = "B";

		private static const C:String = "C";

		private static const D:String = "D";

		private static const E:String = "E";
	}
}

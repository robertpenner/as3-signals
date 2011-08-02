package org.osflash.signals 
{
	import asunit.asserts.*;
	import org.osflash.signals.Signal;
	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.SignalBindingList;

	public class SignalBindingListTest 
	{
		private var signal:Signal;
		private var listenerA:Function;
		private var listenerB:Function;
		private var listenerC:Function;
		private var bindingA:ISignalBinding;
		private var bindingB:ISignalBinding;
		private var bindingC:ISignalBinding;
		private var listOfA:SignalBindingList;
		private var listOfAB:SignalBindingList;
		private var listOfABC:SignalBindingList;
		
		[Before]
		public function setUp():void
		{
			signal = new Signal();
			listenerA = function(e:* = null):void {};
			listenerB = function(e:* = null):void {};
			listenerC = function(e:* = null):void {};
			bindingA = new SignalBinding(listenerA, signal);
			bindingB = new SignalBinding(listenerB, signal);
			bindingC = new SignalBinding(listenerC, signal);
			listOfA = new SignalBindingList(bindingA);
			listOfAB = listOfA.append(bindingB);
			listOfABC = listOfAB.append(bindingC);
		}
		
		[Test]
		public function NIL_has_length_zero():void
		{
			assertEquals(0, SignalBindingList.NIL.length);
		}
		
		[Test]
		public function tail_defaults_to_NIL_if_omitted_in_constructor():void
		{
			const noTail:SignalBindingList = new SignalBindingList(bindingA);
			assertSame(SignalBindingList.NIL, noTail.tail);
		}
		
		[Test]
		public function tail_defaults_to_NIL_if_passed_null_in_constructor():void
		{
			const nullTail:SignalBindingList = new SignalBindingList(bindingA, null);
			assertSame(SignalBindingList.NIL, nullTail.tail);
		}
		
		[Test(expects="ArgumentError")]
		public function constructing_with_null_head_throws_error():void
		{
			new SignalBindingList(null, listOfA);
		}
		
		[Test]
		public function list_with_one_listener_contains_it():void
		{
			assertTrue(listOfA.contains(listenerA));
		}
		
		[Test]
		public function find_the_only_listener_yields_its_binding():void
		{
			assertSame(bindingA, listOfA.find(listenerA));
		}

		[Test]
		public function list_with_one_listener_has_it_in_its_head():void
		{
			assertSame(listenerA, listOfA.head.listener);
		}
		
		[Test]
		public function NIL_does_not_contain_anonymous_listener():void
		{
			assertFalse(SignalBindingList.NIL.contains(function():void {}));
		}

		[Test]
		public function find_in_empty_list_yields_null():void
		{
			assertNull(SignalBindingList.NIL.find(listenerA));
		}		
		
		[Test]
		public function NIL_does_not_contain_null_listener():void
		{
			assertFalse(SignalBindingList.NIL.contains(null));
		}
		
		[Test]
		public function find_the_1st_of_2_listeners_yields_its_binding():void
		{
			assertSame(bindingA, listOfAB.find(listenerA));
		}		
		
		[Test]
		public function find_the_2nd_of_2_listeners_yields_its_binding():void
		{
			assertSame(bindingB, listOfAB.find(listenerB));
		}	
		
		[Test]
		public function find_the_1st_of_3_listeners_yields_its_binding():void
		{
			assertSame(bindingA, listOfABC.find(listenerA));
		}	
		
		[Test]
		public function find_the_2nd_of_3_listeners_yields_its_binding():void
		{
			assertSame(bindingB, listOfABC.find(listenerB));
		}	
		
		[Test]
		public function find_the_3rd_of_3_listeners_yields_its_binding():void
		{
			assertSame(bindingC, listOfABC.find(listenerC));
		}	
		
		[Test]
		public function prepend_a_binding_makes_it_head_of_new_list():void
		{
			const newList:SignalBindingList = listOfA.prepend(bindingB);
			assertSame(bindingB, newList.head);
		}

		[Test]
		public function prepend_a_binding_makes_the_old_list_the_tail():void
		{
			const newList:SignalBindingList = listOfA.prepend(bindingB);
			assertSame(listOfA, newList.tail);
		}
		
		[Test]
		public function after_prepend_binding_new_list_contains_its_listener():void
		{
			const newList:SignalBindingList = listOfA.prepend(bindingB);
			assertTrue(newList.contains(bindingB.listener));
		}
		
		[Test]
		public function append_a_binding_yields_new_list_with_same_head():void
		{
			const oldHead:ISignalBinding = listOfA.head;
			const newList:SignalBindingList = listOfA.append(bindingB);
			assertSame(oldHead, newList.head);
		}
		
		[Test]
		public function append_to_list_of_one_yields_list_of_length_two():void
		{
			const newList:SignalBindingList = listOfA.append(bindingB);
			assertEquals(2, newList.length);
		}
		
		[Test]
		public function after_append_binding_new_list_contains_its_listener():void
		{
			const newList:SignalBindingList = listOfA.append(bindingB);
			assertTrue(newList.contains(bindingB.listener));
		}
		
		[Test]
		public function append_binding_yields_a_different_list():void
		{
			const newList:SignalBindingList = listOfA.append(bindingB);
			assertNotSame(listOfA, newList);
		}

		[Test]
		public function append_null_yields_same_list():void
		{
			const newList:SignalBindingList = listOfA.append(null);
			assertSame(listOfA, newList);
		}
		
		[Test]
		public function filterNot_on_empty_list_yields_same_list():void
		{
			const newList:SignalBindingList = SignalBindingList.NIL.filterNot(listenerA);
			assertSame(SignalBindingList.NIL, newList);
		}
		
		[Test]
		public function filterNot_null_yields_same_list():void
		{
			const newList:SignalBindingList = listOfA.filterNot(null);
			assertSame(listOfA, newList);
		}
		
		[Test]
		public function filterNot_head_from_list_of_1_yields_empty_list():void
		{
			const newList:SignalBindingList = listOfA.filterNot(listOfA.head.listener);
			assertSame(SignalBindingList.NIL, newList);
		}
		
		[Test]
		public function filterNot_1st_listener_from_list_of_2_yields_list_of_2nd_listener():void
		{
			const newList:SignalBindingList = listOfAB.filterNot(listenerA);
			assertSame(listenerB, newList.head.listener);
			assertEquals(1, newList.length);
		}	
		
		[Test]
		public function filterNot_2nd_listener_from_list_of_2_yields_list_of_head():void
		{
			const newList:SignalBindingList = listOfAB.filterNot(listenerB);
			assertSame(listenerA, newList.head.listener);
			assertEquals(1, newList.length);
		}
		
		[Test]
		public function filterNot_2nd_listener_from_list_of_3_yields_list_of_1st_and_3rd():void
		{
			const newList:SignalBindingList = listOfABC.filterNot(listenerB);
			assertSame(listenerA, newList.head.listener);
			assertSame(listenerC, newList.tail.head.listener);
			assertEquals(2, newList.length);
		}
		
	}
}
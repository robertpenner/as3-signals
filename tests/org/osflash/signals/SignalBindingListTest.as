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
		public function NIL_does_not_contain_null_listener():void
		{
			assertFalse(SignalBindingList.NIL.contains(null));
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
	}
}
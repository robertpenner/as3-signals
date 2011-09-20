package org.osflash.signals 
{
	import asunit.asserts.*;
	import org.osflash.signals.Signal;
	import org.osflash.signals.ISlot;
	import org.osflash.signals.SlotList;

	public class SlotListTest 
	{
		private var signal:Signal;
		private var listenerA:Function;
		private var listenerB:Function;
		private var listenerC:Function;
		private var slotA:ISlot;
		private var slotB:ISlot;
		private var slotC:ISlot;
		private var listOfA:SlotList;
		private var listOfAB:SlotList;
		private var listOfABC:SlotList;
		
		[Before]
		public function setUp():void
		{
			signal = new Signal();
			listenerA = function(e:* = null):void {};
			listenerB = function(e:* = null):void {};
			listenerC = function(e:* = null):void {};
			slotA = new Slot(listenerA, signal);
			slotB = new Slot(listenerB, signal);
			slotC = new Slot(listenerC, signal);
			listOfA = new SlotList(slotA);
			listOfAB = listOfA.append(slotB);
			listOfABC = listOfAB.append(slotC);
		}
		
		[Test]
		public function NIL_has_length_zero():void
		{
			assertEquals(0, SlotList.NIL.length);
		}
		
		[Test]
		public function tail_defaults_to_NIL_if_omitted_in_constructor():void
		{
			const noTail:SlotList = new SlotList(slotA);
			assertSame(SlotList.NIL, noTail.tail);
		}
		
		[Test]
		public function tail_defaults_to_NIL_if_passed_null_in_constructor():void
		{
			const nullTail:SlotList = new SlotList(slotA, null);
			assertSame(SlotList.NIL, nullTail.tail);
		}
		
		[Test(expects="ArgumentError")]
		public function constructing_with_null_head_throws_error():void
		{
			new SlotList(null, listOfA);
		}
		
		[Test]
		public function list_with_one_listener_contains_it():void
		{
			assertTrue(listOfA.contains(listenerA));
		}
		
		[Test]
		public function find_the_only_listener_yields_its_slot():void
		{
			assertSame(slotA, listOfA.find(listenerA));
		}

		[Test]
		public function list_with_one_listener_has_it_in_its_head():void
		{
			assertSame(listenerA, listOfA.head.listener);
		}
		
		[Test]
		public function NIL_does_not_contain_anonymous_listener():void
		{
			assertFalse(SlotList.NIL.contains(function():void {}));
		}

		[Test]
		public function find_in_empty_list_yields_null():void
		{
			assertNull(SlotList.NIL.find(listenerA));
		}		
		
		[Test]
		public function NIL_does_not_contain_null_listener():void
		{
			assertFalse(SlotList.NIL.contains(null));
		}
		
		[Test]
		public function find_the_1st_of_2_listeners_yields_its_slot():void
		{
			assertSame(slotA, listOfAB.find(listenerA));
		}		
		
		[Test]
		public function find_the_2nd_of_2_listeners_yields_its_slot():void
		{
			assertSame(slotB, listOfAB.find(listenerB));
		}	
		
		[Test]
		public function find_the_1st_of_3_listeners_yields_its_slot():void
		{
			assertSame(slotA, listOfABC.find(listenerA));
		}	
		
		[Test]
		public function find_the_2nd_of_3_listeners_yields_its_slot():void
		{
			assertSame(slotB, listOfABC.find(listenerB));
		}	
		
		[Test]
		public function find_the_3rd_of_3_listeners_yields_its_slot():void
		{
			assertSame(slotC, listOfABC.find(listenerC));
		}	
		
		[Test]
		public function prepend_a_slot_makes_it_head_of_new_list():void
		{
			const newList:SlotList = listOfA.prepend(slotB);
			assertSame(slotB, newList.head);
		}

		[Test]
		public function prepend_a_slot_makes_the_old_list_the_tail():void
		{
			const newList:SlotList = listOfA.prepend(slotB);
			assertSame(listOfA, newList.tail);
		}
		
		[Test]
		public function after_prepend_slot_new_list_contains_its_listener():void
		{
			const newList:SlotList = listOfA.prepend(slotB);
			assertTrue(newList.contains(slotB.listener));
		}
		
		[Test]
		public function append_a_slot_yields_new_list_with_same_head():void
		{
			const oldHead:ISlot = listOfA.head;
			const newList:SlotList = listOfA.append(slotB);
			assertSame(oldHead, newList.head);
		}
		
		[Test]
		public function append_to_list_of_one_yields_list_of_length_two():void
		{
			const newList:SlotList = listOfA.append(slotB);
			assertEquals(2, newList.length);
		}
		
		[Test]
		public function after_append_slot_new_list_contains_its_listener():void
		{
			const newList:SlotList = listOfA.append(slotB);
			assertTrue(newList.contains(slotB.listener));
		}
		
		[Test]
		public function append_slot_yields_a_different_list():void
		{
			const newList:SlotList = listOfA.append(slotB);
			assertNotSame(listOfA, newList);
		}

		[Test]
		public function append_null_yields_same_list():void
		{
			const newList:SlotList = listOfA.append(null);
			assertSame(listOfA, newList);
		}
		
		[Test]
		public function filterNot_on_empty_list_yields_same_list():void
		{
			const newList:SlotList = SlotList.NIL.filterNot(listenerA);
			assertSame(SlotList.NIL, newList);
		}
		
		[Test]
		public function filterNot_null_yields_same_list():void
		{
			const newList:SlotList = listOfA.filterNot(null);
			assertSame(listOfA, newList);
		}
		
		[Test]
		public function filterNot_head_from_list_of_1_yields_empty_list():void
		{
			const newList:SlotList = listOfA.filterNot(listOfA.head.listener);
			assertSame(SlotList.NIL, newList);
		}
		
		[Test]
		public function filterNot_1st_listener_from_list_of_2_yields_list_of_2nd_listener():void
		{
			const newList:SlotList = listOfAB.filterNot(listenerA);
			assertSame(listenerB, newList.head.listener);
			assertEquals(1, newList.length);
		}	
		
		[Test]
		public function filterNot_2nd_listener_from_list_of_2_yields_list_of_head():void
		{
			const newList:SlotList = listOfAB.filterNot(listenerB);
			assertSame(listenerA, newList.head.listener);
			assertEquals(1, newList.length);
		}
		
		[Test]
		public function filterNot_2nd_listener_from_list_of_3_yields_list_of_1st_and_3rd():void
		{
			const newList:SlotList = listOfABC.filterNot(listenerB);
			assertSame(listenerA, newList.head.listener);
			assertSame(listenerC, newList.tail.head.listener);
			assertEquals(2, newList.length);
		}
		
		// Issue #56
		[Test]
		public function insertWithPriority_adds_4_slots_without_losing_any():void
		{
			var s:PrioritySignal = new PrioritySignal();
			var l1:Function = function():void{};
			var l2:Function = function():void{};
			var l3:Function = function():void{};
			var l4:Function = function():void{};
			var slot1:ISlot = new Slot(l1, s);
			var slot2:ISlot = new Slot(l2, s, false, -1);
			var slot3:ISlot = new Slot(l3, s);
			var slot4:ISlot = new Slot(l4, s);
			var list:SlotList = new SlotList(slot1);
			list = list.insertWithPriority(slot2);
			list = list.insertWithPriority(slot3);
			list = list.insertWithPriority(slot4);
			// This was failing because one slot was being lost.
			assertEquals("number of slots in list", 4, list.length);
			assertEquals(slot1, list.head);
			assertEquals(slot3, list.tail.head);
			assertEquals(slot4, list.tail.tail.head);
			assertEquals(slot2, list.tail.tail.tail.head);
		}
	}
}
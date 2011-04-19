package org.osflash.signals 
{
	import asunit.asserts.*;
	import org.osflash.signals.Signal;
	import org.osflash.signals.SignalBinding;
	import org.osflash.signals.SignalBindingList;

	public class SignalBindingListTest 
	{
		private var signal:Signal;
		private var listenerA:Function;
		private var bindingA:SignalBinding;
		private var bindings:SignalBindingList;
		
		[Before]
		public function setUp():void
		{
			signal = new Signal();
			listenerA = function(e:* = null):void {};
			bindingA = new SignalBinding(listenerA, signal);
			bindings = new SignalBindingList(bindingA);
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
	}
}
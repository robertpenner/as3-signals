package org.osflash.signals.selectives {
	
	import asunit.asserts.*;
	
	/**
	 * Base-tests for ISelectiveSignal
	 */
	public class ISelectiveSignalTestBase {
		
		protected var selective:ISelectiveSignal = null;
		
		/**
		 * Ensure provider is correctly assigned through setter
		 */
		[Test]
		public function provider_through_setter():void {
			var provider:Function = function():void { };
			selective.provider = provider;
			assertSame(selective.provider, provider);
		}
		
		/**
		 * Ensure adding a new selective listener results in an ISelectiveSlot containing the passed in selectivity-value 
		 */
		[Test]
		public function selective_listener_slot_contains_selectivity_value():void {
			var slot:ISelectiveSlot = selective.addFor('LOGIN', function():void { });
			assertTrue(slot is ISelectiveSlot);
			assertEquals(slot.value, 'LOGIN');
		}
		
		/**
		 * Ensure selectity-value on ISelectiveSlot is correctly assigned through setter
		 */
		[Test]
		public function selectivity_value_through_setter():void {
			var slot:ISelectiveSlot = selective.addFor('LOGOUT', function():void { });
			slot.value = 'LOGIN';
			assertEquals(slot.value, 'LOGIN');
		}
		
		/**
		 * Adding a selective listener twice should result in the same ISelectiveSlot
		 */
		[Test]
		public function selective_listener_twice_same_selective_slot():void {
			var listener:Function = function():void { };
			var slot:ISelectiveSlot = selective.addFor('LOGIN', listener);
			assertSame(slot, selective.addFor('LOGIN', listener));
		}
		
		/**
		 * You cannot add a listener twice with differing once-values without removing the relationship first
		 */
		[Test(expects='flash.errors.IllegalOperationError')]
		public function selective_listener_once_values_differ():void {
			var listener:Function = function():void { };
			selective.addFor('LOGIN', listener);
			selective.addOnceFor('LOGIN', listener);
		}
		
		/**
		 * You cannot add() and then addFor() the same listener without removing the relationship first
		 */
		[Test(expects='flash.errors.IllegalOperationError')]
		public function regular_listener_gone_selective():void {
			var listener:Function = function():void { };
			selective.add(listener);
			selective.addFor('LOGIN', listener);
		}
		
		/**
		 * You CAN currently addFor() and then add() the same listener - it will however NOT remove the selectivity
		 * 
		 * TODO: This will be tough to fix as it will require regular signals to take ISelectiveSlots into account
		 */
		[Test]
		public function selective_listener_gone_regular():void {
			var listener:Function = function():void { };
			var slot:ISelectiveSlot = selective.addFor('LOGIN', listener);
			assertSame(slot, selective.add(listener));
		}
		
		/**
		 * You cannot add a listener twice with differing selectivity-values without removing the relationship first
		 */
		[Test(expects='flash.errors.IllegalOperationError')]
		public function selective_listener_selectivity_values_differ():void {
			var listener:Function = function():void { };
			selective.addFor('LOGIN', listener);
			selective.addFor('LOGOUT', listener);
		}
		
	}
	
}

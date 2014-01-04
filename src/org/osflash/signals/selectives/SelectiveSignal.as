package org.osflash.signals.selectives {

	import flash.errors.IllegalOperationError;
	
	import org.osflash.signals.ISlot;
	import org.osflash.signals.PrioritySignal;
	import org.osflash.signals.SlotList;
	
	/**
	 * @inheritDoc
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public class SelectiveSignal extends PrioritySignal implements ISelectiveSignal {
	
		/**
		 * Holds the provider function which - if/when needed - calculates the selectivity-value
		 */
		protected var _provider:Function = null;
		
		/**
		 * Creates a new SelectiveSignal capable of selective dispatching
		 * 
		 * The required parameter provider needs to be of type Function and can be regarded 
		 * as a mini-listener. Therefore its arguments need to match the given valueClasses:
		 * 
		 * <listing version="3.0">
		 *     new SelectiveSignal(function(person:Person):String {
		 *         return person.name;
		 *     }, Person);
		 * </listing>
		 * 
		 * The provider receives the valueObjects that were dispatched and may use these to generate 
		 * the so-called selectivity-value listeners can selectively listen for.
		 * 
		 * @param   provider        Generates the selectivity-value to be used for selective dispatching
		 * @param   valueClasses    Any number of class references that enable type checks in dispatch()
		 */
		public function SelectiveSignal(provider:Function, ...valueClasses) {
			
			// Cannot use super.apply() in constructors, so allow subclasses to call super(provider, valueClasses)
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
			super(valueClasses);
			
			// Validate the given provider
			this.provider = provider;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get provider():Function {
			return _provider;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @throws  ArgumentError <code>ArgumentError</code>: ISelectiveSignal.set provider requires a valid provider of type Function
		 */
		public function set provider(provider:Function):void {
			
			// Ensure the provider is of type Function
			if(!(provider is Function)) {
				throw new ArgumentError('ISelectiveSignal.set provider requires a valid provider of type Function.');
			}
			_provider = provider;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing once-values without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add() and then addFor() the same listener without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing selectivity-values without removing the relationship first.
		 */
		public function addFor(value:Object, listener:Function):ISelectiveSlot {
			return _registerListenerWithPriorityFor(value, listener);
		}

		/**
		 * @inheritDoc
		 * 
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing once-values without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add() and then addFor() the same listener without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing selectivity-values without removing the relationship first.
		 */
		public function addOnceFor(value:Object, listener:Function):ISelectiveSlot {
			return _registerListenerWithPriorityFor(value, listener, true);
		}

		/**
		 * @inheritDoc
		 * 
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing once-values without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add() and then addFor() the same listener without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing selectivity-values without removing the relationship first.
		 */
		public function addWithPriorityFor(value:Object, listener:Function, priority:int=0):ISelectiveSlot {
			return _registerListenerWithPriorityFor(value, listener, false, priority);
		}

		/**
		 * @inheritDoc
		 * 
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing once-values without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add() and then addFor() the same listener without removing the relationship first.
		 * @throws  flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add a listener twice with differing selectivity-values without removing the relationship first.
		 */
		public function addOnceWithPriorityFor(value:Object, listener:Function, priority:int=0):ISelectiveSlot {
			return _registerListenerWithPriorityFor(value, listener, true, priority);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispatch(...valueObjects):void {
			
			// If valueClasses is empty, value objects are not type-checked 
			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;

			// Cannot dispatch fewer objects than declared classes
			if(numValueObjects < numValueClasses) {
				throw new ArgumentError('Incorrect number of arguments. Expected at least ' + numValueClasses + ' but received ' + numValueObjects + '.');
			}
			
			// Cannot dispatch differently typed objects than declared classes
			for (var i:int = 0; i<numValueClasses; ++i) {
				
				// Optimized for the optimistic case that values are correct
				if(valueObjects[i] is _valueClasses[i] || valueObjects[i] === null) {
					continue;
				}
				throw new ArgumentError('Value object <' + valueObjects[i] + '> is not an instance of <' + _valueClasses[i] + '>.');
			}

			// Once per dispatch the selectivity-value may need to be determined
			var value:* = undefined;
			
			var slots:SlotList = slots;
			while(slots.nonEmpty) {
				
				// All slot-types pass-through except ISelectiveSlot as it listens selectively
				if(slots.head is ISelectiveSlot) {
					
					// Ensure to determine the selectivity-value only once
					if(value === undefined) {
						
						// .. and do so by calling the specified provider
						if(numValueObjects === 0) {
							value = _provider();
						}else if(numValueObjects === 1) {
							value = _provider(valueObjects[0]);
						}else if(numValueObjects === 2) {
							value = _provider(valueObjects[0], valueObjects[1]);
						}else if(numValueObjects === 3) {
							value = _provider(valueObjects[0], valueObjects[1], valueObjects[2]);
						}else if(numValueObjects === 4) {
							value = _provider(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3]);
						}else{
							value = _provider.apply(null, valueObjects);
						}
					}
					
					// Only execute this slot if its value strictly matches the selectivity-value
					if(ISelectiveSlot(slots.head).value === value) {
						slots.head.execute(valueObjects);
					}
				}else{
					slots.head.execute(valueObjects);
				}
				slots = slots.tail;
			}
		}

		/**
		 * Registers given listener selectively for given value
		 * 
		 * @return  ISelectiveSlot  the registered selective slot
		 */
		protected function _registerListenerWithPriorityFor(value:*, listener:Function, once:Boolean=false, priority:int=0):ISelectiveSlot {
			
			// Determine whether this listener can be registered
			if(_registrationPossible(value, listener, once)) {
				const slot:ISelectiveSlot = new SelectiveSlot(listener, this, value, once, priority);
				slots = slots.insertWithPriority(slot);
				return slot;
			}
			
			// We can now safely assume that the existing slot is of type ISelectiveSlot
			return ISelectiveSlot(slots.find(listener));
		}
		
		/**
		 * Whether the given listener can be registered as a selective listener on this signal
		 */
		protected function _registrationPossible(value:Object, listener:Function, once:Boolean=false):Boolean {
			
			// No slots registered, allow registration
			if(!slots.nonEmpty) {
				return true;
			}

			// No existing slot, allow registration
			const existingSlot:ISlot = slots.find(listener);
			if(!existingSlot) {
				return true;
			}

			// Once-values differ, throw an exception
			if(existingSlot.once != once) {
				throw new IllegalOperationError('You cannot add a listener twice with differing once-values without removing the relationship first.');
			}
			
			// Listener was previously added as a regular slot, throw an exception
			if(!(existingSlot is ISelectiveSlot)) {
				throw new IllegalOperationError('You cannot add() and then addFor() the same listener without removing the relationship first.');
			}
			
			// Selectivity-values differ, throw an exception 
			if(ISelectiveSlot(existingSlot).value != value) {
				throw new IllegalOperationError('You cannot add a listener twice with differing selectivity-values without removing the relationship first.');
			}
			
			// Listener was already registered
			return false;
		}
		
	}
	
}

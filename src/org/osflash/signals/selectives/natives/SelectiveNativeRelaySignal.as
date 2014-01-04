package org.osflash.signals.selectives.natives {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.osflash.signals.ISlot;	
	import org.osflash.signals.SlotList;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.osflash.signals.selectives.ISelectiveSlot;
	import org.osflash.signals.selectives.SelectiveSlot;
			
	/**
	 * @inheritDoc
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	public class SelectiveNativeRelaySignal extends NativeRelaySignal implements ISelectiveNativeSignal {
		
		/**
		 * Holds the provider function which - if/when needed - calculates the selectivity-value
		 */
		protected var _provider:Function = null;
		
		/**
		 * Creates a new SelectiveNativeRelaySignal capable of selective dispatching
		 * 
		 * This signal relays events dispatched by given target to its listeners and does so 
		 * by its very own dispatching-code (in contrast with NativeSignal)
		 * 
		 * The required parameter provider needs to be of type Function and can be regarded 
		 * as a mini-listener. Therefore its arguments need to match the dispatched event:
		 * 
		 * <listing version="3.0">
		 *     new SelectiveNativeRelaySignal(this.stage, KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):uint {
		 *         return e.keyCode;
		 *     }, KeyboardEvent);
		 * </listing>
		 * 
		 * The provider receives the event that was dispatched and may use it to generate 
		 * the so-called selectivity-value listeners can selectively listen for.
		 * 
		 * @param   target      An object that implements the flash.events.IEventDispatcher interface
		 * @param   eventType   The event string name that would normally be passed to IEventDispatcher.addEventListener()
		 * @param   provider    Generates the selectivity-value to be used for selective dispatching
		 * @param   eventClass  An optional class reference (either Event or a subclass) that enables an event type check in dispatch()
		 */
		public function SelectiveNativeRelaySignal(target:IEventDispatcher, eventType:String, provider:Function, eventClass:Class=null) {
			super(target, eventType, eventClass);
			
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
		 * @throws  ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws  ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
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
		 * @throws  ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws  ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
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
		 * @throws  ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws  ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
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
		 * @throws  ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws  ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		public function addOnceWithPriorityFor(value:Object, listener:Function, priority:int=0):ISelectiveSlot {
			return _registerListenerWithPriorityFor(value, listener, true, priority);
		}
		
		/**
		 * Delegates dispatched events from this signal's target to every slot
		 */
		override protected function onNativeEvent(event:Event):void {
			
			// Once per dispatch the selectivity-value may need to be determined
			var value:* = undefined;
			
			var slots:SlotList = slots;
			while(slots.nonEmpty) {
				
				// All slot-types pass-through except ISelectiveSlot as it listens selectively
				if(slots.head is ISelectiveSlot) {
					
					// Ensure to determine the selectivity-value only once by calling the specified provider
					if(value === undefined) {
						value = _provider(event);
					}
					
					// Only execute this slot if its value strictly matches the selectivity-value
					if(ISelectiveSlot(slots.head).value === value) {
						slots.head.execute1(event);
					}
				}else{
					slots.head.execute1(event);
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
			if(!target) {
				throw new ArgumentError('Target object cannot be null.');
			}
			
			const nonEmptyBefore:Boolean = slots.nonEmpty;
			
			var slot:ISlot = null;
			
			// Determine whether this listener can be registered
			if(_registrationPossible(value, listener, once)) {
				slot = new SelectiveSlot(listener, this, value, once, priority);
				slots = slots.insertWithPriority(slot);
			}else{
				slot = slots.find(listener);
			}
			
			// In case this is the first slot added, listen to this signal's target
			if(nonEmptyBefore != slots.nonEmpty) {
				target.addEventListener(eventType, onNativeEvent, false, priority);
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

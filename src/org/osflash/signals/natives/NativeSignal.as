package org.osflash.signals.natives
{
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Slot;
	import org.osflash.signals.SlotList;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/** 
	 * Allows the eventClass to be set in MXML, e.g.
	 * <natives:NativeSignal id="clicked" eventType="click" target="{this}">{MouseEvent}</natives:NativeSignal>
	 */
	[DefaultProperty("eventClass")]	
	
	/**
	 * The NativeSignal class provides a strongly-typed facade for an IEventDispatcher.
	 * A NativeSignal is essentially a mini-dispatcher locked to a specific event type and class.
	 * It can become part of an interface.
	 */
	public class NativeSignal implements INativeDispatcher
	{
		protected var _target:IEventDispatcher;
		protected var _eventType:String;
		protected var _eventClass:Class;
		protected var _valueClasses:Array;
		protected var slots:SlotList;
		
		/**
		 * Creates a NativeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object on whose behalf the signal is dispatching events.
		 * @param	eventType The type of Event permitted to be dispatched from this signal. Corresponds to Event.type.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch(). Defaults to flash.events.Event if omitted.
		 */
		public function NativeSignal(target:IEventDispatcher = null, eventType:String = "", eventClass:Class = null)
		{
			slots = SlotList.NIL;
			this.target = target;
			this.eventType = eventType;
			this.eventClass = eventClass;
		}
		
		/** @inheritDoc */
		public function get eventType():String { return _eventType; }

		public function set eventType(value:String):void { _eventType = value; }
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }

		public function set eventClass(value:Class):void
		{
			_eventClass = value || Event;
			_valueClasses = [_eventClass];
		}
		
		/** @inheritDoc */
		[ArrayElementType("Class")]
		public function get valueClasses():Array { return _valueClasses; }

		public function set valueClasses(value:Array):void
		{
			eventClass = value && value.length > 0 ? value[0] : null;
		}
		
		/** @inheritDoc */
		public function get numListeners():uint { return slots.length; }
		
		/** @inheritDoc */
		public function get target():IEventDispatcher { return _target; }
		
		public function set target(value:IEventDispatcher):void
		{
			if (value == _target) return;
			if (_target) removeAll();
			_target = value;
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		public function add(listener:Function):ISlot
		{
			return addWithPriority(listener);
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		public function addWithPriority(listener:Function, priority:int = 0):ISlot
		{
			return registerListenerWithPriority(listener, false, priority);
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		public function addOnce(listener:Function):ISlot
		{
			return addOnceWithPriority(listener);
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		public function addOnceWithPriority(listener:Function, priority:int = 0):ISlot
		{
			return registerListenerWithPriority(listener, true, priority);
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):ISlot
		{
			const slot:ISlot = slots.find(listener);
			if (!slot) return null;
			_target.removeEventListener(_eventType, slot.execute1);
			slots = slots.filterNot(listener);
			return slot;
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			var slotsToProcess:SlotList = slots;
			while (slotsToProcess.nonEmpty)
			{
				target.removeEventListener(_eventType, slotsToProcess.head.execute1);
				slotsToProcess = slotsToProcess.tail;
			}
			slots = SlotList.NIL;
		}

		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Event object expected.
		 * @throws ArgumentError <code>ArgumentError</code>: No more than one Event object expected.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Event object cannot be <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Event object [event] is not an instance of [eventClass].
		 * @throws ArgumentError <code>ArgumentError</code>: Event object has incorrect type. Expected [eventType] but was [event.type].
		 */
		public function dispatch(...valueObjects):void
		{
			//TODO: check if ...valueObjects can ever be null.
			if (null == valueObjects) throw new ArgumentError('Event object expected.');

			if (valueObjects.length != 1) throw new ArgumentError('No more than one Event object expected.');

			dispatchEvent(valueObjects[0] as Event);
		}

		/**
		 * Unlike other signals, NativeSignal does not dispatch null
		 * because it causes an exception in EventDispatcher.
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Event object cannot be <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Event object [event] is not an instance of [eventClass].
		 * @throws ArgumentError <code>ArgumentError</code>: Event object has incorrect type. Expected [eventType] but was [event.type].
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if (!target) throw new ArgumentError('Target object cannot be null.');
			if (!event)  throw new ArgumentError('Event object cannot be null.');
			
			if (!(event is eventClass))
				throw new ArgumentError('Event object '+event+' is not an instance of '+eventClass+'.');
				
			if (event.type != eventType)
				throw new ArgumentError('Event object has incorrect type. Expected <'+eventType+'> but was <'+event.type+'>.');
			
			return target.dispatchEvent(event);
		}
		
		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISlot
		{
			if (!target) throw new ArgumentError('Target object cannot be null.');

			if (registrationPossible(listener, once))
			{
				const slot:ISlot = new Slot(listener, this, once, priority);
				// Not necessary to insertWithPriority() because the target takes care of ordering.
				slots = slots.prepend(slot);
				_target.addEventListener(_eventType, slot.execute1, false, priority);
				return slot;
			}
			
			return slots.find(listener);
		}

		protected function registrationPossible(listener:Function, once:Boolean):Boolean
		{
			if (!slots.nonEmpty) return true;

			const existingSlot:ISlot = slots.find(listener);
			if (existingSlot)
			{
				if (existingSlot.once != once)
				{
					// If the listener was previously added, definitely don't add it again.
					// But throw an exception if their once value differs.
					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}

				// Listener was already added.
				return false;
			}

			// This listener has not been added before.
			return true;
		}

	}
}

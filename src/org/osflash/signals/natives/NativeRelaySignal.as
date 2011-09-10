package org.osflash.signals.natives
{
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Signal;
	import org.osflash.signals.Slot;
	import org.osflash.signals.SlotList;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The NativeRelaySignal class is used to relay events from an IEventDispatcher
	 * to listeners.
	 * The difference as compared to NativeSignal is that
	 * NativeRelaySignal has its own dispatching code,
	 * whereas NativeSignal uses the IEventDispatcher to dispatch.
	 */
	public class NativeRelaySignal extends Signal implements INativeDispatcher
	{
		protected var _target:IEventDispatcher;
		protected var _eventType:String;
		protected var _eventClass:Class;

		/**
		 * Creates a new NativeRelaySignal instance to relay events from an IEventDispatcher.
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType	The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 * Because the target is an IEventDispatcher,
		 * eventClass needs to be flash.events.Event or a subclass of it.
		 */
		public function NativeRelaySignal(target:IEventDispatcher, eventType:String, eventClass:Class = null)
		{
			super(eventClass || Event);

			this.eventType = eventType;
			this.eventClass = eventClass;
			this.target = target;
		}

		
		/** @inheritDoc */
		public function get target():IEventDispatcher
		{
			return _target;
		}

		public function set target(value:IEventDispatcher):void
		{
			if (value == _target) return;
			if (_target) removeAll();
			_target = value;
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

		override public function set valueClasses(value:Array):void
		{
			eventClass = (value && value.length > 0) ? value[0] : null;
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		override public function add(listener:Function):ISlot
		{
			return addWithPriority(listener);
		}

		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot addOnce() then add() the same listener without removing the relationship first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws ArgumentError <code>ArgumentError</code>: Target object cannot be <code>null</code>.
		 */
		override public function addOnce(listener:Function):ISlot
		{
			return addOnceWithPriority(listener);
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
		public function addOnceWithPriority(listener:Function, priority:int = 0):ISlot
		{
			return registerListenerWithPriority(listener, true, priority);
		}
		
		/** @inheritDoc */
		override public function remove(listener:Function):ISlot
		{
			const nonEmptyBefore:Boolean = slots.nonEmpty;
			const slot:ISlot = super.remove(listener);
			if (nonEmptyBefore != slots.nonEmpty) 
				target.removeEventListener(eventType, onNativeEvent);
			return slot;
		}

		/**
		 * @inheritDoc
		 */
		override public function removeAll():void
		{
			if (target) target.removeEventListener(eventType, onNativeEvent);
			super.removeAll();
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
		override public function dispatch(...valueObjects):void
		{
			if (null == valueObjects) throw new ArgumentError('Event object expected.');

			if (valueObjects.length != 1) throw new ArgumentError('No more than one Event object expected.');

			dispatchEvent(valueObjects[0] as Event);
		}

		/**
		 * Unlike other signals, NativeRelaySignal does not dispatch null
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

		protected function onNativeEvent(event:Event):void
		{
			var slotsToProcess:SlotList = slots;

			while (slotsToProcess.nonEmpty)
			{
				slotsToProcess.head.execute1(event);
				slotsToProcess = slotsToProcess.tail;
			}
		}
		
		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISlot
		{
			if (!target) throw new ArgumentError('Target object cannot be null.');
			const nonEmptyBefore:Boolean = slots.nonEmpty;
			
			var slot:ISlot = null;
			if (registrationPossible(listener, once))
			{
				slot = new Slot(listener, this, once, priority);
				slots = slots.insertWithPriority(slot);
			}
			else
				slot = slots.find(listener);
				
			// Account for cases where the same listener is added twice.
			if (nonEmptyBefore != slots.nonEmpty)
				target.addEventListener(eventType, onNativeEvent, false, priority);
				
			return slot;
		}
		
	}
}

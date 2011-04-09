package org.osflash.signals.natives
{
	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.SignalBinding;
	import org.osflash.signals.SignalBindingList;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

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
			removeAll();
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
			eventClass = value && value.length > 0 ? value[0] : null;
		}
		
		override public function add(listener:Function):ISignalBinding
		{
			return addWithPriority(listener);
		}
		
		/** @inheritDoc */
		public function addWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			const nonEmptyBefore: Boolean = bindings.nonEmpty;
			
			// Try to add first because it may throw an exception.
			const binding:ISignalBinding = registerListenerWithPriority(listener, false, priority);
			// Account for cases where the same listener is added twice.
			if (nonEmptyBefore != bindings.nonEmpty)
				IEventDispatcher(target).addEventListener(eventType, onNativeEvent, false, priority);
			
			return binding;
		}

		override public function addOnce(listener:Function):ISignalBinding
		{
			return addOnceWithPriority(listener);
		}

		/** @inheritDoc */
		public function addOnceWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			if (null == target) throw new ArgumentError('Target object expected.');
			
			const nonEmptyBefore:Boolean = bindings.nonEmpty;

			// Try to add first because it may throw an exception.
			const binding:ISignalBinding = registerListenerWithPriority(listener, true, priority);
			// Account for cases where the same listener is added twice.
			if (nonEmptyBefore != bindings.nonEmpty)
				IEventDispatcher(target).addEventListener(eventType, onNativeEvent, false, priority);
			
			return binding;
		}
		
		/** @inheritDoc */
		override public function remove(listener:Function):ISignalBinding
		{
			const nonEmptyBefore: Boolean = bindings.nonEmpty;

			const binding :ISignalBinding = super.remove(listener);

			if (nonEmptyBefore != bindings.nonEmpty) IEventDispatcher(target).removeEventListener(eventType, onNativeEvent);

			return binding;
		}

		/**
		 * @inheritDoc
		 */
		override public function removeAll(): void
		{
			if(bindings.nonEmpty) IEventDispatcher(target).removeEventListener(eventType, onNativeEvent);
			super.removeAll();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispatch(...valueObjects):void
		{
			if (null == valueObjects) throw new ArgumentError('Event object expected.');

			if (valueObjects.length != 1) throw new ArgumentError('No more than one Event object expected.');

			dispatchEvent(valueObjects[0] as Event);
		}

		/**
		 * Unlike other signals, NativeSignal does not dispatch null
		 * because it causes an exception in EventDispatcher.
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if (null == event) throw new ArgumentError('Event object expected.');

			if (!(event is eventClass))
				throw new ArgumentError('Event object '+event+' is not an instance of '+eventClass+'.');

			if (event.type != eventType)
				throw new ArgumentError('Event object has incorrect type. Expected <'+eventType+'> but was <'+event.type+'>.');
			
			return target.dispatchEvent(event);
		}

		protected function onNativeEvent(event: Event): void
		{
			var bindingsToProcess:SignalBindingList = bindings;

			while (bindingsToProcess.nonEmpty)
			{
				bindingsToProcess.head.execute1(event);
				bindingsToProcess = bindingsToProcess.tail;
			}
		}
		
		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISignalBinding
		{
			if (!bindings.nonEmpty || verifyRegistrationOf(listener, once))
			{
				const binding:ISignalBinding = new SignalBinding(listener, once, this, priority);
				bindings = bindings.insertWithPriority(binding);
				(existing ||= new Dictionary())[listener] = true;
				return binding;
			}
			
			return bindings.find(listener);
		}
		
	}
}

package org.osflash.signals.natives
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.SignalBinding;
	import org.osflash.signals.SignalBindingList;

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
	public class NativeSignal implements IPrioritySignal, INativeDispatcher
	{
		protected var _eventDispatcher:IEventDispatcher;
		protected var _eventType:String;
		protected var _eventClass:Class;
		protected var _valueClasses:Array;

		protected var bindings:SignalBindingList;
		protected var existing:Dictionary;

		/**
		 * Creates a NativeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object on whose behalf the signal is dispatching events.
		 * @param	eventType The type of Event permitted to be dispatched from this signal. Corresponds to Event.type.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch(). Defaults to flash.events.Event if omitted.
		 */
		public function NativeSignal(target:IEventDispatcher = null, eventType:String = "", eventClass:Class = null)
		{
			bindings = SignalBindingList.NIL;
			existing = null;

			this.eventDispatcher = target;
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
		public function get numListeners():uint { return bindings.length; }
		
		/** @inheritDoc */
		public function get eventDispatcher():IEventDispatcher { return _eventDispatcher; }
		
		public function set eventDispatcher(value:IEventDispatcher):void
		{
			if (value == _eventDispatcher) return;

			removeAll();
			_eventDispatcher = value;
		}

		/** @inheritDoc */
		[Deprecated(replacement="eventDispatcher", since="0.9")]
		public function get target():IEventDispatcher { return eventDispatcher; }

		[Deprecated(replacement="eventDispatcher", since="0.9")]
		public function set target(value:IEventDispatcher):void { eventDispatcher = value; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):Function
		{
			return addWithPriority(listener)
		}
		
		/** @inheritDoc */
		//TODO: @throws
		public function addWithPriority(listener:Function, priority:int = 0):Function
		{
			registerListener(listener, false, priority);
			return listener;
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):Function
		{
			return addOnceWithPriority(listener)
		}
		
		/** @inheritDoc */
		public function addOnceWithPriority(listener:Function, priority:int = 0):Function
		{
			registerListener(listener, true, priority);
			return listener;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):Function
		{
			bindings = bindings.filterNot(listener);

			if (!bindings.nonEmpty)
			{
				if(existing != null)
				{
					eventDispatcher.removeEventListener(eventType, onNativeEvent);
					existing = null;
				}
			}
			else delete existing[listener];

			return listener;
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			if (null != existing) eventDispatcher.removeEventListener(eventType, onNativeEvent);

			bindings = SignalBindingList.NIL;
			existing = null;
		}

		/**
		 * @inheritDoc
		 */
		public function dispatch(...valueObjects):void
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

			return eventDispatcher.dispatchEvent(event);
		}
		
		protected function registerListener(listener:Function, once:Boolean = false, priority:int = 0):void
		{
			if (listener.length != 1)
				throw new ArgumentError('Listener for native event must declare exactly 1 argument.');
				
			if (!bindings.nonEmpty || verifyRegistrationOf(listener, once))
			{
				bindings = bindings.insertWithPriority(new SignalBinding(listener, once, this, priority));

				if (null == existing)
				{
					existing = new Dictionary();
					eventDispatcher.addEventListener(eventType, onNativeEvent, false, priority);
				}

				existing[listener] = true;
			}
		}

		protected function verifyRegistrationOf(listener: Function,  once: Boolean): Boolean
		{
			if(!existing || !existing[listener]) return true;

			const existingBinding:ISignalBinding = bindings.find(listener);

			if (null != existingBinding)
			{
				if (existingBinding.once != once)
				{
					//
					// If the listener was previously added, definitely don't add it again.
					// But throw an exception if their once value differs.
					//

					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}

				//
				// Listener was already added.
				//

				return false;
			}

			//
			// This listener has not been added before.
			//

			return true;
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
	}
}

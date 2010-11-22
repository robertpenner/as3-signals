package org.osflash.signals
{
	import flash.errors.IllegalOperationError;
	
	import org.osflash.signals.events.IBubbleEventHandler;
	import org.osflash.signals.events.IEvent;

	/** 
	 * Allows the valueClasses to be set in MXML, e.g.
	 * <signals:Signal id="nameChanged">{[String, uint]}</signals:Signal>
	 */
	[DefaultProperty("valueClasses")]	
	
	/**
	 * Signal dispatches events to multiple listeners.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://github.com/robertpenner/as3-signals/">http://github.com/robertpenner/as3-signals/</a>
	 */
	public class DeluxeSignal extends Signal implements IPrioritySignal
	{
		protected var _target:Object;
		
		/**
		 * Creates a DeluxeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new DeluxeSignal(this, String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function DeluxeSignal(target:Object = null, ...valueClasses)
		{
			_target = target;
			super(valueClasses);
		}
		
		/** @inheritDoc */
		/** @inheritDoc */
		public function get target():Object { return _target; }
		
		/** @inheritDoc */
		public function set target(value:Object):void
		{
			if (value == _target) return;
			removeAll();
			_target = value;
		}
		
		//TODO: @throws
		override public function add(listener:Function):Function
		{
			return addWithPriority(listener);
		}
		
		public function addWithPriority(listener:Function, priority:int = 0):Function
		{
			registerListenerWithPriority(listener, false, priority);
			return listener;
		}
		
		override public function addOnce(listener:Function):Function
		{
			return addOnceWithPriority(listener);
		}
		
		/** @inheritDoc */
		public function addOnceWithPriority(listener:Function, priority:int = 0):Function
		{
			registerListenerWithPriority(listener, true, priority);
			return listener;
		}
		
		/** @inheritDoc */
		override public function dispatch(...valueObjects):void
		{
			// Validate value objects against pre-defined value classes.
			var valueObject:Object;
			var valueClass:Class;
			var len:int = _valueClasses.length;
			for (var i:int = 0; i < len; i++)
			{
				// null is allowed to pass through.
				if ( (valueObject = valueObjects[i]) === null
					|| valueObject is (valueClass = _valueClasses[i]) )
					continue;
					
				throw new ArgumentError('Value object <' + valueObject
					+ '> is not an instance of <' + valueClass + '>.');
			}

			var event:IEvent = valueObjects[0] as IEvent;
			if (event)
			{
				// clone re-dispatched event
				if (event.target)
				{
					//todo can we get rid of this somehow?
					valueObjects[0] = event = event.clone();
				}
				event.target = this.target;
				event.currentTarget = this.target;
				event.signal = this;
			}

			var slotsToProcess: SignalSlotList = slots;

			//// Call listeners.
			if (slotsToProcess.nonEmpty)
			{
				// During a dispatch, add() and remove() should clone listeners array instead of modifying it.
				switch (valueObjects.length)
				{
					case 0:
						while (slotsToProcess.nonEmpty)
						{
							slotsToProcess.head.execute0();
							slotsToProcess = slotsToProcess.tail;
						}
						break;
						
					case 1:
						const singleValue:Object = valueObjects[0];
						while (slotsToProcess.nonEmpty)
						{
							slotsToProcess.head.execute1(singleValue);
							slotsToProcess = slotsToProcess.tail;
						}
						break;
						
					case 2:
						const value1:Object = valueObjects[0];
						const value2:Object = valueObjects[1];
						while (slotsToProcess.nonEmpty)
						{
							slotsToProcess.head.execute2(value1, value2);
							slotsToProcess = slotsToProcess.tail;
						}
						break;
						
					default:
						while (slotsToProcess.nonEmpty)
						{
							slotsToProcess.head.execute(valueObjects);
							slotsToProcess = slotsToProcess.tail;
						}
				}
			}
			
			if (!event || !event.bubbles) return;

			//// Bubble the event as far as possible.
			var currentTarget:Object = this.target;
			while ( currentTarget && currentTarget.hasOwnProperty("parent")
				//todo check if we can optimize this and hasOwnProperty is needed
					&& (currentTarget = currentTarget.parent) )
			{
				if (currentTarget is IBubbleEventHandler)
				{
					// onEventBubbled() can stop the bubbling by returning false.
					if (!IBubbleEventHandler(event.currentTarget = currentTarget).onEventBubbled(event))
						break;
				}
			}
		}
		
		override protected function registerListener(listener:Function, once:Boolean = false):void
		{
			registerListenerWithPriority(listener, once);
		}
		
		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):void
		{
			// function.length is the number of arguments.
			if (listener.length < _valueClasses.length)
			{
				var argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
				throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+_valueClasses.length+' to match the given value classes.');
			}

			const slot:SignalSlot = new SignalSlot(listener, once, this, priority);

			// Process the first listener as quickly as possible.
			if (!slots.nonEmpty)
			{
				slots = new SignalSlotList(slot, slots);
				return;
			}
			
			if (slots.contains(listener))
			{
				// If the listener was previously added, definitely don't add it again.
				// But throw an exception in some cases, as the error messages explain.
				var prevSlot:SignalSlot = slots.find(listener);
				if (prevSlot._isOnce && !once)
				{
					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}
				else if (!prevSlot._isOnce && once)
				{
					throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
				}
				// Listener was already added, so do nothing.
				return;
			}
			
			slots = slots.insertWithPriority(slot);
		}
		
	}
}

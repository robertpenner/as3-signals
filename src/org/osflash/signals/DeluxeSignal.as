package org.osflash.signals
{
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
			
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0]:valueClasses;
			
			super(valueClasses);
		}

		/** @inheritDoc */
		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			if (value == _target) return;
			removeAll();
			_target = value;
		}

		// TODO: @throws
		override public function add(listener:Function):ISignalBinding
		{
			return addWithPriority(listener);
		}

		override public function addOnce(listener:Function):ISignalBinding
		{
			return addOnceWithPriority(listener);
		}

		/** @inheritDoc */
		public function addWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			return registerListenerWithPriority(listener, false, priority);
		}

		/** @inheritDoc */
		public function addOnceWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			return registerListenerWithPriority(listener, true, priority);
		}

		/** @inheritDoc */
		override public function dispatch(...valueObjects):void
		{
			// Validate value objects against pre-defined value classes.

			var valueObject:Object;
			var valueClass:Class;

			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;
			
			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. '+
					'Expected at least '+numValueClasses+' but received '+
					numValueObjects+'.');
			}

			for (var i:int = 0; i < numValueClasses; i++)
			{
				valueObject = valueObjects[i];
				valueClass = _valueClasses[i];

				if (valueObject === null || valueObject is valueClass) continue;

				throw new ArgumentError('Value object <'+valueObject
					+'> is not an instance of <'+valueClass+'>.');
			}

			// Extract and clone event object if necessary.

			var event:IEvent = valueObjects[0] as IEvent;

			if (event)
			{
				if (event.target)
				{
					event = event.clone();
					valueObjects[0] = event;
				}

				event.target = target;
				event.currentTarget = target;
				event.signal = this;
			}

			// Broadcast to listeners.

			var bindingsToProcess:SignalBindingList = bindings;
			while (bindingsToProcess.nonEmpty)
			{
				bindingsToProcess.head.execute(valueObjects);
				bindingsToProcess = bindingsToProcess.tail;
			}

			// Bubble the event as far as possible.

			if (!event || !event.bubbles) return;

			var currentTarget:Object = target;

			while (currentTarget && currentTarget.hasOwnProperty("parent") && (currentTarget = currentTarget["parent"]))
			{
				if (currentTarget is IBubbleEventHandler)
				{
					// onEventBubbled() can stop the bubbling by returning false.
					if (!IBubbleEventHandler(event.currentTarget = currentTarget).onEventBubbled(event))
						break;
				}
			}
		}

		override protected function registerListener(listener:Function, once:Boolean = false):ISignalBinding
		{
			return registerListenerWithPriority(listener, once);
		}

		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISignalBinding
		{
			if (registrationPossible(listener, once))
			{
				const binding:ISignalBinding = new SignalBinding(listener, once, this, priority);
				bindings = bindings.insertWithPriority(binding);
				return binding;
			}
			
			return bindings.find(listener);
		}
	}
}

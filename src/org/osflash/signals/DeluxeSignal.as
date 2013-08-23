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
	public class DeluxeSignal extends PrioritySignal
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
		public function get target():Object	{ return _target; }

		public function set target(value:Object):void
		{
			if (value == _target) return;
			removeAll();
			_target = value;
		}

		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Incorrect number of arguments.
		 * @throws ArgumentError <code>ArgumentError</code>: Value object is not an instance of the appropriate valueClasses Class.
		 */
		override public function dispatch(...valueObjects):void
		{
			// Validate value objects against pre-defined value classes.
			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;
			
			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. '+
					'Expected at least '+numValueClasses+' but received '+
					numValueObjects+'.');
			}

			// Cannot dispatch differently typed objects than declared classes.
			for (var i:int = 0; i < numValueClasses; i++)
			{
				// Optimized for the optimistic case that values are correct.
				if (valueObjects[i] is _valueClasses[i] || valueObjects[i] === null) 
					continue;
					
				throw new ArgumentError('Value object <'+valueObjects[i]
					+'> is not an instance of <'+_valueClasses[i]+'>.');
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
			var slotsToProcess:SlotList = slots;
			while (slotsToProcess.nonEmpty)
			{
				slotsToProcess.head.execute(valueObjects);
				slotsToProcess = slotsToProcess.tail;
			}

			// Bubble the event as far as possible.
			if (!event || !event.bubbles) return;

			var currentTarget:Object = target;

			while (currentTarget && currentTarget.hasOwnProperty("parent"))
			{
				currentTarget = currentTarget["parent"];
				if (!currentTarget) break;
				
				if (currentTarget is IBubbleEventHandler)
				{
					// onEventBubbled() can stop the bubbling by returning false.
					if (!IBubbleEventHandler(event.currentTarget = currentTarget).onEventBubbled(event))
						break;
				}
			}
		}

	}
}

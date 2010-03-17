package org.osflash.signals
{
	import org.osflash.signals.events.IBubbleEventHandler;
	import org.osflash.signals.events.IEvent;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

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
	public class DeluxeSignal implements IDeluxeSignal, IDispatcher
	{
		protected var _target:Object;
		protected var _valueClasses:Array;
		protected var listenerBoxes:Array;
		protected var listenersNeedCloning:Boolean = false;
		
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
		public function DeluxeSignal(target:Object, ...valueClasses)
		{
			_target = target;
			listenerBoxes = [];
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			if (valueClasses.length == 1 && valueClasses[0] is Array)
				valueClasses = valueClasses[0];
			setValueClasses(valueClasses);
		}
		
		/** @inheritDoc */
		public function get valueClasses():Array { return _valueClasses; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listenerBoxes.length; }
		
		/** @inheritDoc */
		public function get target():Object { return _target; }
		
		/** @inheritDoc */
		public function set target(value:Object):void
		{
			if (value == _target) return;
			removeAll();
			_target = value;
		}
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function, priority:int = 0):void
		{
			registerListener(listener, false, priority);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function, priority:int = 0):void
		{
			registerListener(listener, true, priority);
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			if (indexOfListener(listener) == -1) return;
			if (listenersNeedCloning)
			{
				listenerBoxes = listenerBoxes.slice();
				listenersNeedCloning = false;
			}
			listenerBoxes.splice(indexOfListener(listener), 1);
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			// Looping backwards is more efficient when removing array items.
			for (var i:uint = listenerBoxes.length; i--; )
			{
				remove(listenerBoxes[i].listener as Function);
			}
		}
		
		/** @inheritDoc */
		public function dispatch(...valueObjects):void
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
					valueObjects[0] = event = event.clone();
				}
				event.target = this.target;
				event.currentTarget = this.target;
				event.signal = this;
			}
			
			// During a dispatch, add() and remove() should clone listeners array instead of modifying it.
			listenersNeedCloning = true;
			//// Call listeners.
			var listener:Function;
			if (listenerBoxes.length)
			{
				//TODO: investigate performance of various approaches
				
				for each (var listenerBox:Object in listenerBoxes)
				{
					listener = listenerBox.listener;
					if (listenerBox.once) remove(listener);
					listener.apply(null, valueObjects);
				}
			}
			
			listenersNeedCloning = false;
			
			if (!event || !event.bubbles) return;

			//// Bubble the event as far as possible.
			var currentTarget:Object = this.target;
			while ( currentTarget && currentTarget.hasOwnProperty("parent")
					&& (currentTarget = currentTarget.parent) )
			{
				if (currentTarget is IBubbleEventHandler)
				{
					//TODO: incorporate secoif's Boolean return to check whether to continue.
					IBubbleEventHandler(event.currentTarget = currentTarget).onEventBubbled(event);
					break;
				}
			}
		}
		
		protected function indexOfListener(listener:Function):int
		{
			for (var i:int = listenerBoxes.length; i--; )
			{
				if (listenerBoxes[i].listener == listener) return i;
			}
			return -1;
		}
				
		protected function setValueClasses(valueClasses:Array):void
		{
			_valueClasses = valueClasses || [];
			
			for (var i:int = _valueClasses.length; i--; )
			{
				if (!(_valueClasses[i] is Class))
				{
					throw new ArgumentError('Invalid valueClasses argument: item at index ' + i
						+ ' should be a Class but was:<' + _valueClasses[i] + '>.');
				}
			}
		}
		
		protected function registerListener(listener:Function, once:Boolean = false, priority:int = 0):void
		{
			// function.length is the number of arguments.
			if (listener.length < _valueClasses.length)
			{
				var argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
				throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+_valueClasses.length+' to match the given value classes.');
			}
			
			var listenerBox:Object = { listener:listener, once:once, priority:priority };
			// Process the first listener as quickly as possible.
			if (!listenerBoxes.length)
			{
				listenerBoxes[0] = listenerBox;
				return;
			}
			
			var prevListenerIndex:int = indexOfListener(listener);
			if (prevListenerIndex >= 0)
			{
				// If the listener was previously added, definitely don't add it again.
				// But throw an exception in some cases, as the error messages explain.
				var prevListenerBox:Object = listenerBoxes[prevListenerIndex];
				if (prevListenerBox.once && !once)
				{
					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}
				else if (!prevListenerBox.once && once)
				{
					throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
				}
				// Listener was already added, so do nothing.
				return;
			}
			
			if (listenersNeedCloning)
			{
				listenerBoxes = listenerBoxes.slice();
				listenersNeedCloning = false;
			}
		
			// Assume the listeners are already sorted by priority
			// and insert in the right spot. For listeners with the same priority,
			// we must preserve the order in which they were added.
			var len:int = listenerBoxes.length;
			for (var i:int = 0; i < len; i++)
			{
				// As soon as a lower-priority listener is found, go in front of it.
				if (priority > listenerBoxes[i].priority)
				{
					listenerBoxes.splice(i, 0, listenerBox);
					return;
				}
			}
			
			// If we made it this far, the new listener has lowest priority, so put it last.
			listenerBoxes[listenerBoxes.length] = listenerBox;
		}
		
	}
}

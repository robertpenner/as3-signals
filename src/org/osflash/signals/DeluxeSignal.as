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
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
		
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new DeluxeSignal(this, String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 */
		public function DeluxeSignal(target:Object, ...valueClasses)
		{
			_target = target;
			listeners = [];
			onceListeners = new Dictionary();
			if (!valueClasses) return;
			
			_valueClasses = valueClasses.concat();
			// loop backwards
			for (var i:int = _valueClasses.length; i--; )
			{
				if (!(_valueClasses[i] is Class))
				{
					throw new ArgumentError('Invalid valueClasses argument: item at index ' + i
						+ ' should be a Class but was:<' + _valueClasses[i] + '>.');
				}
			}
		}
		
		/** @inheritDoc */
		public function get valueClasses():Array { return _valueClasses; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listeners.length; }
		
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
			if (onceListeners[listener])
				throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
		
			createListenerRelationship(listener, priority);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function, priority:int = 0):void
		{
			if (indexOfListener(listener) >= 0 && !onceListeners[listener])
				throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
			
			createListenerRelationship(listener, priority);
			onceListeners[listener] = true;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			listeners.splice(indexOfListener(listener), 1);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			// Looping backwards is more efficient when removing array items.
			for (var i:uint = listeners.length; i--; )
			{
				remove(listeners[i] as Function);
			}
		}
		
		/** @inheritDoc */
		public function dispatch(...valueObjects):void
		{
			var len:int = _valueClasses.length;
			for (var i:int = 0; i < len; i++)
			{
				if (!(valueObjects[i] is _valueClasses[i]))
					throw new ArgumentError('Value object <'+valueObjects[i]+'> is not an instance of <'+_valueClasses[i]+'>.');
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
			
			//// Call listeners.
			var listener:Function;
			if (listeners.length)
			{
				//TODO: investigate performance of various approaches
				
				// Clone listeners array because add/remove may occur during the dispatch.
				for each (var listenerBox:Object in listeners.concat())
				{
					listener = listenerBox.listener;
					if (onceListeners[listener]) remove(listener);
					listener.apply(null, valueObjects);
				}
			}
			
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
		
		protected function indexOfListener(listener:Object):int
		{
			for (var i:int = listeners.length; i--; )
			{
				if (listeners[i].listener == listener) return i;
			}
			return -1;
		}
				
		protected function createListenerRelationship(listener:Function, priority:int):void
		{
			// function.length is the number of arguments.
			if (listener.length < _valueClasses.length)
			{
				var argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
				throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+_valueClasses.length+' to match the given value classes.');
			}
			
			var listenerBox:Object = {listener:listener, priority:priority};
			// Process the first listener as quickly as possible.
			if (!listeners.length)
			{
				listeners[0] = listenerBox;
				return;
			}
			
			// Don't add the same listener twice.
			if (indexOfListener(listener) >= 0)
				return;
			
			// Assume the listeners are already sorted by priority
			// and insert in the right spot. For listeners with the same priority,
			// we must preserve the order in which they were added.
			var len:int = listeners.length;
			for (var i:int = 0; i < len; i++)
			{
				// As soon as a lower-priority listener is found, go in front of it.
				if (priority > listeners[i].priority)
				{
					listeners.splice(i, 0, listenerBox);
					return;
				}
			}
			
			// If we made it this far, the new listener has lowest priority, so put it last.
			listeners[listeners.length] = listenerBox;
		}
		
	}
}

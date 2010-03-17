package org.osflash.signals
{
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
	public class Signal implements ISignal, IDispatcher
	{
		protected var _valueClasses:Array;		// of Class
		protected var listeners:Array;			// of Function
		protected var onceListeners:Dictionary;	// of Function
		protected var listenersNeedCloning:Boolean = false;
		
		/**
		 * Creates a Signal instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function Signal(...valueClasses)
		{
			listeners = [];
			onceListeners = new Dictionary();
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			if (valueClasses.length == 1 && valueClasses[0] is Array)
				valueClasses = valueClasses[0];
			setValueClasses(valueClasses);
		}
		
		/** @inheritDoc */
		public function get valueClasses():Array { return _valueClasses; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listeners.length; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):void
		{
			registerListener(listener);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):void
		{
			registerListener(listener, true);
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			var index:int = listeners.indexOf(listener);
			if (index == -1) return;
			if (listenersNeedCloning)
			{
				listeners = listeners.slice();
				listenersNeedCloning = false;
			}
			listeners.splice(index, 1);
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

			if (!listeners.length) return;
			
			//// Call listeners.
			
			// During a dispatch, add() and remove() should clone listeners array instead of modifying it.
			listenersNeedCloning = true;
			var listener:Function;
			switch (valueObjects.length)
			{
				case 0:
					for each (listener in listeners)
					{
						if (onceListeners[listener]) remove(listener);
						listener();
					}
					break;
					
				case 1:
					for each (listener in listeners)
					{
						if (onceListeners[listener]) remove(listener);
						listener(valueObjects[0]);
					}
					break;
					
				default:
					for each (listener in listeners)
					{
						if (onceListeners[listener]) remove(listener);
						listener.apply(null, valueObjects);
					}
			}
			listenersNeedCloning = false;
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
		
		protected function registerListener(listener:Function, once:Boolean = false):void
		{
			// function.length is the number of arguments.
			if (listener.length < _valueClasses.length)
			{
				var argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
				throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+_valueClasses.length+' to match the given value classes.');
			}
			
			// If there are no previous listeners, add the first one as quickly as possible.
			if (!listeners.length)
			{
				listeners[0] = listener;
				if (once) onceListeners[listener] = true;
				return;
			}
						
			if (listeners.indexOf(listener) >= 0)
			{
				// If the listener was previously added, definitely don't add it again.
				// But throw an exception in some cases, as the error messages explain.
				if (onceListeners[listener] && !once)
				{
					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}
				else if (!onceListeners[listener] && once)
				{
					throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
				}
				// Listener was already added, so do nothing.
				return;
			}
			
			if (listenersNeedCloning)
			{
				listeners = listeners.slice();
				listenersNeedCloning = false;
			}
				
			// Faster than push().
			listeners[listeners.length] = listener;
			if (once) onceListeners[listener] = true;
		}
	}
}

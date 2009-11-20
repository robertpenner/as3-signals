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
	public class SimpleSignal implements ISimpleSignal
	{
		protected var _target:Object;
		protected var _eventClass:Class;
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
		
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function SimpleSignal(target:Object, eventClass:Class = null)
		{
			_target = target;
			_eventClass = eventClass;
			listeners = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listeners.length; }
		
		/** @inheritDoc */
		public function get target():Object { return _target; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):void
		{
			if (onceListeners[listener])
				throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
		
			createListenerRelationship(listener);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):void
		{
			if (listeners.indexOf(listener) >= 0 && !onceListeners[listener])
				throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
			
			createListenerRelationship(listener);
			onceListeners[listener] = true;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			listeners.splice(listeners.indexOf(listener), 1);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			listeners.length = 0;
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function dispatch(eventObject:Object = null, ...args):void
		{
			if (_eventClass && !(eventObject is _eventClass))
				throw new ArgumentError('Event object '+eventObject+' is not an instance of '+_eventClass+'.');

			//// Send eventObject to each listener.
			if (listeners.length)
			{
				if (args.length && eventObject)
				{
					args.unshift(eventObject);
				}
				
				//TODO: investigate performance of various approaches
				// Clone listeners array because add/remove may occur during the dispatch.
				for each (var listener:Function in listeners.concat())
				{
					//TODO: Maybe put this conditional outside the loop.
					if (eventObject == null)
						listener();
					else if (args.length)
						listener.apply(null, args);
					else
						listener(eventObject);
				}
			}
			
			for (var onceListener:Object in onceListeners)
			{
				remove(onceListener as Function);
			}
		}
		
		protected function createListenerRelationship(listener:Function):void
		{
			// function.length is the number of arguments.
			if (eventClass && !listener.length)
				throw new ArgumentError('Listener must declare at least 1 argument when eventClass is specified.');
			
			// Process the first listener as quickly as possible.
			if (!listeners.length)
			{
				listeners[0] = listener;
				return;
			}
			
			// Don't add the same listener twice.
			if (listeners.indexOf(listener) >= 0)
				return;
						
			listeners[listeners.length] = listener;
		}
	}
}

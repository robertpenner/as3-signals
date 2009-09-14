package org.osflash.signals
{
	import flash.utils.Dictionary;
	import org.osflash.signals.IEvent;
	import org.osflash.signals.IBubbleEventHandler;

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
	public class Signal implements ISignal
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
		public function Signal(target:Object, eventClass:Class = null)
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
		public function add(listener:Function, priority:int = 0):void
		{
			// function.length is the number of arguments.
			if (eventClass && !listener.length)
				throw new ArgumentError('Listener must declare at least 1 argument when eventClass is specified.');

			var listenerBox:Object = { listener:listener, priority:priority };
			// Process the first listener as quickly as possible.
			if (!listeners.length)
			{
				listeners[0] = listenerBox;
				return;
			}
			// Don't add the same listener twice.
			if (indexOfListener(listener) >= 0) return;
			
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
			// Lowest priority goes last.
			listeners.push(listenerBox);
		}
		
		protected function indexOfListener(listener:Object):int
		{
			for (var i:int = listeners.length; i--; )
			{
				if (listeners[i].listener == listener) return i;
			}
			return -1;
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function, priority:int = 0):void
		{
			add(listener, priority); // call this first in case it throws an error
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
			listeners.length = 0;
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function dispatch(eventObject:Object = null, ...args):void
		{
			if (_eventClass && !(eventObject is _eventClass))
				throw new ArgumentError('Event object '+eventObject+' is not an instance of '+_eventClass+'.');

			var event:IEvent = eventObject as IEvent;
			if (event)
			{
				//TODO: figure out when the event should be cloned
				if (!event.target) event.target = this.target; // write-once
				event.currentTarget = this.target;
				event.signal = this;
			}
			
			//// Send eventObject to each listener.
			if (listeners.length)
			{
				if (args.length && eventObject)
				{
					args.unshift(eventObject);
				}
				
				//TODO: investigate performance of various approaches
				// Clone listeners array because add/remove may occur during the dispatch.
				for each (var listenerBox:Object in listeners.concat())
				{
					var listener:Function = listenerBox.listener;
					//TODO: Maybe put this conditional outside the loop.
					if (!eventObject)
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
			
			if (!event || !event.bubbles) return;

			//// Bubble the event as far as possible.
			var currentTarget:Object = this.target;
			while ( currentTarget && currentTarget.hasOwnProperty("parent")
					&& (currentTarget = currentTarget.parent) )
			{
				if (currentTarget is IBubbleEventHandler)
				{
					IBubbleEventHandler(currentTarget).onEventBubbled(event);
					currentTarget = null;
				}
			}
		}
	}
}

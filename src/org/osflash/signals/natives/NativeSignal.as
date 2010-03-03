package org.osflash.signals.natives
{
	import org.osflash.signals.IDeluxeSignal;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * The NativeSignal class provides a strongly-typed facade for an IEventDispatcher.
	 * A NativeSignal is essentially a mini-dispatcher locked to a specific event type and class.
	 * It can become part of an interface.
	 */
	public class NativeSignal implements IDeluxeSignal, INativeDispatcher
	{
		protected var _target:IEventDispatcher;
		protected var _eventType:String;
		protected var _eventClass:Class;
		protected var listenerCmds:Array;
		protected var onceListeners:Dictionary;
				
		/**
		 * Creates a NativeSignal instance to dispatch events on behalf of a target object.
		 * @param	target The object on whose behalf the signal is dispatching events.
		 * @param	eventType The type of Event permitted to be dispatched from this signal. Corresponds to Event.type.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch(). Defaults to flash.events.Event if omitted.
		 */
		public function NativeSignal(target:IEventDispatcher, eventType:String, eventClass:Class = null)
		{
			_target = target;
			_eventType = eventType;
			_eventClass = eventClass || Event;
			listenerCmds = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventType():String { return _eventType; }
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get valueClasses():Array { return [_eventClass]; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listenerCmds.length; }
		
		/** @inheritDoc */
		public function get target():IEventDispatcher { return _target; }
		
		/** @inheritDoc */
		public function set target(value:IEventDispatcher):void { _target = value; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function, priority:int = 0):void
		{
			if (onceListeners[listener])
				throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
		
			registerListener(listener, false, priority);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function, priority:int = 0):void
		{
			// If the listener has been added as once, don't do anything.
			if (onceListeners[listener]) return;
			if (indexOfListener(listener) >= 0 && !onceListeners[listener])
				throw new IllegalOperationError('You cannot add() then addOnce() the same listener without removing the relationship first.');
			
			registerListener(listener, true, priority);
			onceListeners[listener] = true;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			if (indexOfListener(listener) == -1) return;
			listenerCmds.splice(indexOfListener(listener), 1);
			_target.removeEventListener(_eventType, listener);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			for (var i:int = listenerCmds.length; i--; )
			{
				remove(listenerCmds[i].execute as Function);
			}
		}
		
		/**
		 * Unlike other signals, NativeSignal does not dispatch null
		 * because it causes an exception in EventDispatcher.
		 * @inheritDoc
		 */
		public function dispatch(event:Event):Boolean
		{
			if (!(event is _eventClass))
				throw new ArgumentError('Event object '+event+' is not an instance of '+_eventClass+'.');
				
			if (event.type != _eventType)
				throw new ArgumentError('Event object has incorrect type. Expected <'+_eventType+'> but was <'+event.type+'>.');

			return _target.dispatchEvent(event);
		}
		
		protected function registerListener(listener:Function, once:Boolean = false, priority:int = 0):void
		{
			// function.length is the number of arguments.
			if (listener.length != 1)
				throw new ArgumentError('Listener for native event must declare exactly 1 argument.');
				
			// Don't add same listener twice.
			if (indexOfListener(listener) >= 0)
				return;
			
			var listenerCmd:Object = { listener:listener };
			
			if (once)
			{
				var signal:NativeSignal = this;
				listenerCmd.execute = function(event:Event):void
				{
					signal.remove(arguments.callee);
					listener(event);
				};
			}
			else
			{
				listenerCmd.execute = listener;
			}
				
			listenerCmds[listenerCmds.length] = listenerCmd;
			_target.addEventListener(_eventType, listenerCmd.execute, false, priority);
		}
		
		protected function indexOfListener(listener:Function):int
		{
			for (var i:int = listenerCmds.length; i--; )
			{
				if (listenerCmds[i].execute == listener) return i;
			}
			return -1;
		}
	}
}

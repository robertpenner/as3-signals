package org.osflash.signals
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;

	/**
	 * The NativeSignal class uses an ISignal interface as a facade for an IEventDispatcher.
	 */
	public class NativeSignal implements INativeSignal
	{
		protected var _target:IEventDispatcher;
		protected var _name:String;
		protected var _eventClass:Class;
		protected var listeners:Array;
		protected var onceListeners:Dictionary;
				
		/**
		 * Creates a Signal instance to dispatch events on behalf of a target object.
		 * @param	target The object the signal is dispatching events on behalf of.
		 * @param	eventClass An optional class reference that enables an event type check in dispatch().
		 */
		public function NativeSignal(target:IEventDispatcher, name:String, eventClass:Class = null)
		{
			_target = IEventDispatcher(target);
			_name = name;
			_eventClass = eventClass || Event;
			listeners = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listeners.length; }
		
		/** @inheritDoc */
		public function get target():IEventDispatcher { return _target; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function, priority:int = 0):void
		{
			if (listener.length != 1)
				throw new ArgumentError('Listener for native event must declare exactly 1 argument.');
				
			if (listeners.indexOf(listener) >= 0) return; // Don't add same listener twice.
			listeners.push(listener);
			_target.addEventListener(_name, listener, false, priority);
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
			listeners.splice(listeners.indexOf(listener), 1);
			_target.removeEventListener(_name, listener);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			for (var i:int = listeners.length-1; i >= 0; i--)
			{
				remove(listeners[i]);
			}
		}
		
		/** @inheritDoc */
		public function dispatch(event:Event):Boolean
		{
			if (!(event is _eventClass))
				throw new ArgumentError('Event object '+event+' is not an instance of '+_eventClass+'.');
				
			if (event.type != _name)
				throw new ArgumentError('Event object has incorrect type. Expected <'+_name+'> but was <'+event.type+'>.');

			var result:Boolean = _target.dispatchEvent(event);
			
			for (var onceListener:Object in onceListeners)
			{
				remove(onceListener as Function);
			}
			
			return result;
		}
	}
}

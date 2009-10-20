package org.osflash.signals
{
	import org.osflash.signals.error.AmbiguousRelationshipError;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * The NativeSignal class uses an ISignal interface as a facade for an IEventDispatcher.
	 */
	public class NativeSignal implements INativeSignal
	{
		protected var _target:IEventDispatcher;
		protected var _name:String;
		protected var _eventClass:Class;
		protected var listenerCmds:Array;
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
			listenerCmds = [];
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function get eventClass():Class { return _eventClass; }
		
		/** @inheritDoc */
		public function get numListeners():uint { return listenerCmds.length; }
		
		/** @inheritDoc */
		public function get target():IEventDispatcher { return _target; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function, priority:int = 0):void
		{
			if (onceListeners[listener])
				throw new AmbiguousRelationshipError('You cannot addOnce() then add() the same listener without removing the relationship first.');
		
			createListenerRelationship(listener, false, priority);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function, priority:int = 0):void
		{
			if (indexOfListener(listener) >= 0 && !onceListeners[listener])
				throw new AmbiguousRelationshipError('You cannot add() then addOnce() the same listener without removing the relationship first.');
			
			createListenerRelationship(listener, true, priority);
			onceListeners[listener] = true;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):void
		{
			listenerCmds.splice(indexOfListener(listener), 1);
			_target.removeEventListener(_name, listener);
			delete onceListeners[listener];
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			for (var i:int = listenerCmds.length; i--; )
			{
				_target.removeEventListener(_name, listenerCmds[i].execute);
			}
			listenerCmds.length = 0;
			onceListeners = new Dictionary();
		}
		
		/** @inheritDoc */
		public function dispatch(event:Event):Boolean
		{
			if (!(event is _eventClass))
				throw new ArgumentError('Event object '+event+' is not an instance of '+_eventClass+'.');
				
			if (event.type != _name)
				throw new ArgumentError('Event object has incorrect type. Expected <'+_name+'> but was <'+event.type+'>.');

			return _target.dispatchEvent(event);
		}
		
		protected function createListenerRelationship(listener:Function, once:Boolean = false, priority:int = 0):void
		{
			// function.length is the number of arguments.
			if (listener.length != 1)
				throw new ArgumentError('Listener for native event must declare exactly 1 argument.');
				
			// Don't add same listener twice.
			if (indexOfListener(listener) >= 0)
				return;
			
			var listenerCmd:ListenerCommand = new ListenerCommand(listener, once, this);
			listenerCmds[listenerCmds.length] = listenerCmd;
			_target.addEventListener(_name, listenerCmd.execute, false, priority);
		}
		
		protected function indexOfListener(listener:Function):int
		{
			for (var i:int = listenerCmds.length; i--; )
			{
				if (listenerCmds[i].listener == listener) return i;
			}
			return -1;
		}
	}
}

import flash.events.Event;
import org.osflash.signals.INativeSignal;

class ListenerCommand
{
	public var listener:Function;
	public var execute:Function;
	
	protected var signal:INativeSignal;
	
	public function ListenerCommand(listener:Function, once:Boolean = false, signal:INativeSignal = null)
	{
		this.listener = listener;
		this.execute = once ? executeAndRemove : listener;
		this.signal = signal;
	}
	
	protected function executeAndRemove(event:Event):void
	{
		listener(event);
		signal.remove(arguments.callee);
		listener = null;
		signal = null;
		execute = null;
	}
}


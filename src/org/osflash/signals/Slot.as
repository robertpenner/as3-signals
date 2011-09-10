package org.osflash.signals 
{
    /**
     * The Slot class represents a signal slot.
     *
     * @author Robert Penner
	 * @author Joa Ebert
     */
	public class Slot implements ISlot
	{
		protected var _signal:IOnceSignal;
		protected var _enabled:Boolean = true;
		protected var _listener:Function;
		protected var _once:Boolean = false;
		protected var _priority:int = 0;
		protected var _params:Array;
		
		/**
		 * Creates and returns a new Slot object.
		 *
		 * @param listener The listener associated with the slot.
		 * @param signal The signal associated with the slot.
		 * @param once Whether or not the listener should be executed only once.
		 * @param priority The priority of the slot.
		 *
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 * @throws Error <code>Error</code>: Internal signal reference has not been set yet.
		 */
		public function Slot(listener:Function, signal:IOnceSignal, once:Boolean = false, priority:int = 0)
		{
			_listener = listener;
			_once = once;
			_signal = signal;
			_priority = priority;
							
			verifyListener(listener);
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute0():void
		{
			if (!_enabled) return;
			if (_once) remove();
			if (_params && _params.length)
			{
				_listener.apply(null, _params);
				return;
			}
			_listener();
		}		
		
		/**
		 * @inheritDoc
		 */
		public function execute1(value:Object):void
		{
			if (!_enabled) return;
			if (_once) remove();
			if (_params && _params.length)
			{
				_listener.apply(null, [value].concat(_params));
				return;
			}
			_listener(value);
		}		

		/**
		 * @inheritDoc
		 */
		public function execute(valueObjects:Array):void
		{
			if (!_enabled) return;
			if (_once) remove();
			
			// If we have parameters, add them to the valueObject
			// Note: This could be expensive if we're after the fastest dispatch possible.
			if (_params && _params.length)
			{
				valueObjects = valueObjects.concat(_params);
			}
			
			// NOTE: simple ifs are faster than switch: http://jacksondunstan.com/articles/1007
			const numValueObjects:int = valueObjects.length;
			if (numValueObjects == 0)
			{
				_listener();
			}
			else if (numValueObjects == 1)
			{
				_listener(valueObjects[0]);
			}
			else if (numValueObjects == 2)
			{
				_listener(valueObjects[0], valueObjects[1]);
			}
			else if (numValueObjects == 3)
			{
				_listener(valueObjects[0], valueObjects[1], valueObjects[2]);
			}
			else
			{
				_listener.apply(null, valueObjects);
			}
		}

		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>. Did you want to set enabled to false instead?
		 * @throws Error <code>Error</code>: Internal signal reference has not been set yet.
		 */
		public function get listener():Function
		{
			return _listener;
		}

		public function set listener(value:Function):void
		{
			if (null == value) throw new ArgumentError(
					'Given listener is null.\nDid you want to set enabled to false instead?');
			
			verifyListener(value);
			_listener = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get once():Boolean { return _once; }

		/**
		 * @inheritDoc
		 */
		public function get priority():int { return _priority; }

		/**
		 * Creates and returns the string representation of the current object.
		 *
		 * @return The string representation of the current object.
		 */
		public function toString():String
		{
			return "[Slot listener: "+_listener+", once: "+_once
											+", priority: "+_priority+", enabled: "+_enabled+"]";
		}

		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean { return _enabled; }

		public function set enabled(value:Boolean):void	{ _enabled = value; }
		
		/**
		 * @inheritDoc
		 */		
		public function get params():Array { return _params; }
		
		public function set params(value:Array):void { _params = value; }
		
		/**
		 * @inheritDoc
		 */
		public function remove():void
		{
			_signal.remove(_listener);
		}

		protected function verifyListener(listener:Function): void
		{
			if (null == listener)
			{
				throw new ArgumentError('Given listener is null.');
			}

			if (null == _signal)
			{
				throw new Error('Internal signal reference has not been set yet.');
			}
			
		}
	}
}
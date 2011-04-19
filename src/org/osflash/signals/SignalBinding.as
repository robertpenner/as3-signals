package org.osflash.signals 
{
    /**
     * The SignalBinding class represents a signal binding.
     *
     * @author Robert Penner
	 * @author Joa Ebert
	 * @private
     */
	public final class SignalBinding implements ISignalBinding
	{
		private var _signal:ISignal;
		private var _enabled:Boolean = true;
		private var _strict:Boolean = true;
		private var _listener:Function;
		private var _once:Boolean = false;
		private var _priority:int = 0;
		private var _params:Array;
		
		/**
		 * Creates and returns a new SignalBinding object.
		 *
		 * @param listener The listener associated with the binding.
		 * @param once Whether or not the listener should be executed only once.
		 * @param signal The signal associated with the binding.
		 * @param priority The priority of the binding.
		 *
		 * @throws ArgumentError An error is thrown if the given listener closure is <code>null</code>.
		 */
		public function SignalBinding(listener:Function, signal:ISignal, once:Boolean = false, priority:int = 0)
		{
			_listener = listener;
			_once = once;
			_signal = signal;
			_priority = priority;
							
			// Work out what the strict mode is from the signal and set it here. You can change
			// the value of strict mode on the binding itself at a later date.
			_strict = signal.strict;
			
			verifyListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function execute(valueObjects:Array):void
		{
			if (!_enabled) return;
			if (_once) remove();
			
			// If we have parameters, add them to the valueObject
			// Note: This could be exensive if we're after the fastest dispatch possible.
			if(null != _params && _params.length > 0)
			{
				// Should there be any checking on the params against the listener?
				valueObjects = valueObjects.concat(_params);
			}
			
			if(_strict)
			{
				// Dispatch as normal
				const numValueObjects : int = valueObjects.length;
				if(numValueObjects == 0)
				{
					_listener();
				}
				else if(numValueObjects == 1)
				{
					_listener(valueObjects[0]);
				}
				else if(numValueObjects == 2)
				{
					_listener(valueObjects[0], valueObjects[1]);
				}
				else if(numValueObjects == 3)
				{
					_listener(valueObjects[0], valueObjects[1], valueObjects[2]);
				}
				else
				{
					_listener.apply(null, valueObjects);
				}
			}
			else
			{
				// We're going to pass everything in one bulk run so that varargs can be 
				// passed through to the listeners
				_listener.apply(null, valueObjects);
			}
		}

		/**
		 * @inheritDoc
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
			return "[SignalBinding listener: "+_listener+", once: "+_once
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
		public function get strict():Boolean { return _strict; }

		public function set strict(value:Boolean):void
		{ 
			_strict = value;
			
			// Check that when we move from one strict mode to another strict mode and verify the 
			// listener again.
			verifyListener(listener);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get params() : Array { return _params; }
		
		public function set params(value : Array) : void { _params = value; }
		
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
			
			const numListenerArgs:int = listener.length;
			const argumentString:String = (numListenerArgs == 1) ? 'argument' : 'arguments';
			
			if (_strict)
			{
				if (numListenerArgs < _signal.valueClasses.length)
				{
					throw new ArgumentError('Listener has '+numListenerArgs+' '+argumentString
							+' but it needs to be '+
							_signal.valueClasses.length+' to match the signal\'s value classes.');
				}
			}
		}
	}
}
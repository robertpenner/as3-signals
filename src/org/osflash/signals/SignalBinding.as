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
		/**
		 * Private backing variable for the <code>signal</code> property.
		 * @private
		 */
		private var _signal:ISignal;

		/**
		 * Private backing variable for the <code>enabled</code> property.
		 * @private
		 */
		private var _enabled:Boolean = true;
		
		/**
		 * Private backing variable for the <code>strict</code> property.
		 * @private
		 */
		private var _strict:Boolean = true;
		
		/**
		 * Private backing variable for the <code>listener</code> property.
		 *
		 * Visible in the signals package for fast access.
		 * @private
		 */
		private var _listener:Function;

		/**
		 * Private backing variable for the <code>once</code> property.
		 *
		 * Visible in the signals package for fast access.
		 * @private
		 */
		private var _once:Boolean;

		/**
		 * Private backing variable for the <code>priority</code> property.
		 *
		 * Visible in the signals package for fast access.
		 * @private
		 */
		private var _priority:int;
		
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
		public function SignalBinding(listener:Function, once:Boolean = false, signal:ISignal = null, priority:int = 0)
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
			
			if(_strict)
			{
				// Note: this is a tiny bit slower than the before (1-3ms in MassDispatchPerformance), 
				// because every valueObject look up is now in the binding and not in the ISignal. 
				// We should possibly look at passing the value AOT?
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
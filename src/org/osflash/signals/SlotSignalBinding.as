package org.osflash.signals
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SlotSignalBinding implements ISignalBinding
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
		 * @private
		 */
		private var _slot:ISignalBindingSlot;
		
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
		public function SlotSignalBinding(listener:Function, once:Boolean = false, signal:ISignal = null, priority:int = 0)
		{
			_once = once;
			_signal = signal;
			_priority = priority;
			
			// Work out what the strict mode is from the signal and set it here. You can change
			// the value of strict mode on the binding itself at a later date.
			_strict = signal.strict;
			
			verifyListener(listener);
			
			_slot = new SignalBindingSlot(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function execute(valueObjects:Array):void
		{
			if (!_enabled) return;
			if (_once) remove();
			
			// Here we're using what the listener.length is to provide the correct arguments.
			const numArguments : int = _slot.numArguments;
			if(numArguments == 0)
			{
				_slot.execute0();	
			}
			else if(numArguments == 1)
			{
				_slot.execute1(valueObjects[0]);
			}
			else if(numArguments == 2)
			{
				_slot.execute2(valueObjects[0], valueObjects[1]);
			}
			else if(numArguments == 3)
			{
				_slot.execute3(valueObjects[0], valueObjects[1], valueObjects[2]);
			}
			else
			{
				_slot.execute.apply(null, valueObjects);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get listener():Function
		{
			return _slot.listener;
		}

		public function set listener(value:Function):void
		{
			if (null == value) throw new ArgumentError(
					'Given listener is null.\nDid you want to call pause() instead?');
			
			verifyListener(value);
			
			_slot.listener = value;
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
			return "[SlotSignalBinding listener: "+listener+", once: "+_once
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
			_signal.remove(_slot.listener);
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

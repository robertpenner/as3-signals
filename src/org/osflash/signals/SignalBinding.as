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
		 * Private backing variable for the <code>paused</code> property.
		 * @private
		 */
		private var _paused:Boolean;

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
			_once = once;
			_signal = signal;
			_priority = priority;

			this.listener = listener;
		}

		/**
		 * @inheritDoc
		 */
		public function execute(valueObjects:Array):void
		{
			if (!_paused)
			{
				if (_once) remove();
				_listener.apply(null, valueObjects);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function execute0():void
		{
			if (!_paused)
			{
				if (_once) remove();
				_listener();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function execute1(value1:Object):void
		{
			if (!_paused)
			{
				if (_once) remove();
				_listener(value1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function execute2(value1:Object, value2:Object):void
		{
			if (!_paused)
			{
				if (_once) remove();
				_listener(value1, value2);
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
					'Given listener is null.\nDid you want to call pause() instead?');

			if(null == _signal) throw new Error(
				'Internal signal reference has not been set yet.');

			if(value.length < _signal.valueClasses.length)
			{
				// trim the length of the arguments passed in to match what the function takes if
				// it's less. varargs functions return 0 for their argument length, so this means if
				// someone listens with a varargs function, no arguments will be inserted into the
				// varargs.
				_listener = function(...args) :* {
					args.length = value.length;
					return value.apply(this, args);
				};
			} else {
				_listener = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get once():Boolean
		{
			return _once;
		}

		/**
		 * @inheritDoc
		 */
		public function get priority():int
		{
			return _priority;
		}

		/**
		 * Creates and returns the string representation of the current object.
		 *
		 * @return The string representation of the current object.
		 */
		public function toString():String
		{
			return "[SignalBinding listener: "+_listener+", once: "+_once+", priority: "+_priority+", paused: "+_paused+"]";
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			_paused = true;
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			_paused = false;
		}

		/**
		 * @inheritDoc
		 */
		public function remove():void
		{
			_signal.remove(_listener);
		}

	}
}

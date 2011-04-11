package org.osflash.signals
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalBindingSlot implements ISignalBindingSlot
	{

		/**
		 * Private backing variable for the <code>listener</code> property.
		 * @private
		 */
		private var _listener : Function;
		
		/**
		 * Private backing variable for the <code>numArguments</code> property.
		 * @private
		 */
		private var _numArguments : int;

		public function SignalBindingSlot(listener : Function)
		{
			_listener = listener;
			// Use the listener length to generate the numArguments
			_numArguments = listener.length;
		}

		/**
		 * @inheritDoc
		 */
		public function execute0() : void
		{
			_listener();
		}

		/**
		 * @inheritDoc
		 */
		public function execute1(valueObject1:Object) : void
		{
			_listener(valueObject1);
		}

		/**
		 * @inheritDoc
		 */
		public function execute2(valueObject1:Object, valueObject2:Object) : void
		{
			_listener(valueObject1, valueObject2);
		}

		/**
		 * @inheritDoc
		 */
		public function execute3(valueObject1:Object, valueObject2:Object, valueObject3:Object) : void
		{
			_listener(valueObject1, valueObject2, valueObject3);
		}

		/**
		 * @inheritDoc
		 */
		public function execute(...args) : void
		{
			_listener.apply(null, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get listener() : Function { return _listener; }
		public function set listener(value : Function) : void {	_listener = value; }

		/**
		 * @inheritDoc
		 */
		public function get numArguments() : int { return _numArguments; }		
	}
}

package org.osflash.signals
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	

	/** 
	 * Allows the valueClasses to be set in MXML, e.g.
	 * <signals:Signal id="nameChanged">{[String, uint]}</signals:Signal>
	 */
	[DefaultProperty("valueClasses")]	
	
	/**
	 * Signal dispatches events to a single listener.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://github.com/robertpenner/as3-signals/">http://github.com/robertpenner/as3-signals/</a>
	 */
	public class SingleSignal implements ISignal
	{
		protected var _valueClasses:Array;		// of Class
		
		protected var _strict:Boolean = true;

		protected var binding:SignalBinding;
		
		/**
		 * Creates a Signal instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function SingleSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			this.valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
		}
		
		/** @inheritDoc */
		[ArrayElementType("Class")]
		public function get valueClasses():Array { return _valueClasses; }
		
		public function set valueClasses(value:Array):void
		{
			// Clone so the Array cannot be affected from outside.
			_valueClasses = value ? value.slice() : [];
			for (var i:int = _valueClasses.length; i--; )
			{
				if (!(_valueClasses[i] is Class))
				{
					throw new ArgumentError('Invalid valueClasses argument: ' +
						'item at index ' + i + ' should be a Class but was:<' +
						_valueClasses[i] + '>.' + getQualifiedClassName(_valueClasses[i]));
				}
			}
		}
		
		/** @inheritDoc */
		public function get numListeners():uint { return null == binding ? 0 : 1; }
		
		/**
		 * @inheritDoc
		 */
		public function get strict():Boolean { return _strict; }

		public function set strict(value:Boolean):void { _strict = value; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):ISignalBinding
		{
			return registerListener(listener);
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):ISignalBinding
		{
			return registerListener(listener, true);
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):ISignalBinding
		{
			if(binding && binding.listener == listener)
			{
				// This will need to be a clone I think
				const bind : ISignalBinding = binding;
				
				binding = null;
				
				return bind;
			}

			return null;
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			if(binding) binding.remove();
			binding = null;
		}
		
		/** @inheritDoc */
		public function dispatch(...valueObjects):void
		{
			//
			// Validate value objects against pre-defined value classes.
			//

			var valueObject:Object;
			var valueClass:Class;

			const numValueClasses: int = valueClasses.length;
			const numValueObjects: int = valueObjects.length;

			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. '+
					'Expected at least '+numValueClasses+' but received '+
					numValueObjects+'.');
			}
			
			for (var i: int = 0; i < numValueClasses; ++i)
			{
				valueObject = valueObjects[i];
				valueClass = valueClasses[i];

				if (valueObject === null || valueObject is valueClass) continue;
					
				throw new ArgumentError('Value object <'+valueObject
					+'> is not an instance of <'+valueClass+'>.');
			}

			//
			// Broadcast to listeners.
			//
			
			if (null != binding)
			{
				binding.execute(valueObjects);
			}
		}
		
		protected function registerListener(listener:Function, once:Boolean = false):ISignalBinding
		{
			if (null != binding) 
			{
				//
				// If the listener exits previously added, definitely don't add it.
				//
				
				throw new IllegalOperationError('You cannot add or addOnce with a listener already added, remove the current listener first.');
			}
			
			if (!binding || verifyRegistrationOf(listener, once))
			{
				binding = new SignalBinding(listener, once, this);
				
				return binding;
			}
			
			//
			// TODO : Question about returning null, as you're adding the same listener twice. We 
			// could possibly have a way to locate the binding by listener?
			//
			return binding;
		}

		protected function verifyRegistrationOf(listener: Function,  once: Boolean): Boolean
		{
			if(!binding || binding.listener != listener) return false;
			
			const existingBinding:ISignalBinding = binding;

			if (null != existingBinding)
			{
				if (existingBinding.once != once)
				{
					//
					// If the listener was previously added, definitely don't add it again.
					// But throw an exception if their once value differs.
					//

					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}

				//
				// Listener was already added.
				//

				return false;
			}

			//
			// This listener has not been added before.
			//
			
			return true;
		}
	}
}

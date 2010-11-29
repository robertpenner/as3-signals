package org.osflash.signals
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/** 
	 * Allows the valueClasses to be set in MXML, e.g.
	 * <signals:Signal id="nameChanged">{[String, uint]}</signals:Signal>
	 */
	[DefaultProperty("valueClasses")]	
	
	/**
	 * Signal dispatches events to multiple listeners.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://github.com/robertpenner/as3-signals/">http://github.com/robertpenner/as3-signals/</a>
	 */
	public class Signal implements ISignal
	{
		protected var _valueClasses:Array;		// of Class

		protected var bindings:SignalBindingList;
		protected var existing:Dictionary;
		
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
		public function Signal(...valueClasses)
		{
			bindings = SignalBindingList.NIL;
			existing = null;

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
		public function get numListeners():uint { return bindings.length; }
		
		/** @inheritDoc */
		//TODO: @throws
		public function add(listener:Function):Function
		{
			registerListener(listener);
			return listener;
		}
		
		/** @inheritDoc */
		public function addOnce(listener:Function):Function
		{
			registerListener(listener, true);
			return listener;
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):Function
		{
			bindings = bindings.filterNot(listener);

			if (!bindings.nonEmpty) existing = null;
			else delete existing[listener];

			return listener;
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			bindings = SignalBindingList.NIL;
			existing = null;
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

			var bindingsToProcess:SignalBindingList = bindings;

			if (bindingsToProcess.nonEmpty)
			{
				if (numValueObjects == 0)
				{
					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute0();
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
				else if (numValueObjects == 1)
				{
					const singleValue:Object = valueObjects[0];

					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute1(singleValue);
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
				else if (numValueObjects == 2)
				{
					const value1:Object = valueObjects[0];
					const value2:Object = valueObjects[1];

					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute2(value1, value2);
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
				else
				{
					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute(valueObjects);
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
			}
		}

		protected function registerListener(listener:Function, once:Boolean = false):void
		{
			if (!bindings.nonEmpty || verifyRegistrationOf(listener, once))
			{
				bindings = new SignalBindingList(new SignalBinding(listener, once, this), bindings);

				if (null == existing) existing = new Dictionary();

				existing[listener] = true;
			}
		}

		protected function verifyRegistrationOf(listener: Function,  once: Boolean): Boolean
		{
			if(!existing || !existing[listener]) return true;
			
			const existingBinding:ISignalBinding = bindings.find(listener);

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

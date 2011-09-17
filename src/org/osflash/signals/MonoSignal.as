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
	 * A MonoSignal can have only one listener.
	 */
	public class MonoSignal implements ISignal
	{
		protected var _valueClasses:Array;		// of Class
		
		protected var slot:Slot;
		
		/**
		 * Creates a MonoSignal instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function MonoSignal(...valueClasses)
		{
			// Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
			this.valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Invalid valueClasses argument: item at index should be a Class but was not.
		 */
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
		public function get numListeners():uint { return slot ? 1 : 0; }
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add or addOnce with a listener already added, remove the current listener first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		public function add(listener:Function):ISlot
		{
			return registerListener(listener);
		}
		
		/**
		 * @inheritDoc
		 * @throws flash.errors.IllegalOperationError <code>IllegalOperationError</code>: You cannot add or addOnce with a listener already added, remove the current listener first.
		 * @throws ArgumentError <code>ArgumentError</code>: Given listener is <code>null</code>.
		 */
		public function addOnce(listener:Function):ISlot
		{
			return registerListener(listener, true);
		}
		
		/** @inheritDoc */
		public function remove(listener:Function):ISlot
		{
			if (slot && slot.listener == listener)
			{
				const theSlot:ISlot = slot;
				slot = null;
				return theSlot;
			}

			return null;
		}
		
		/** @inheritDoc */
		public function removeAll():void
		{
			if (slot) slot.remove();
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Incorrect number of arguments.
		 * @throws ArgumentError <code>ArgumentError</code>: Value object is not an instance of the appropriate valueClasses Class.
		 */
		public function dispatch(...valueObjects):void
		{
			// If valueClasses is empty, value objects are not type-checked. 
			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;

			// Cannot dispatch fewer objects than declared classes.
			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. '+
					'Expected at least '+numValueClasses+' but received '+
					numValueObjects+'.');
			}
			
			// Cannot dispatch differently typed objects than declared classes.
			for (var i:int = 0; i < numValueClasses; i++)
			{
				// Optimized for the optimistic case that values are correct.
				if (valueObjects[i] is _valueClasses[i] || valueObjects[i] === null) 
					continue;
					
				throw new ArgumentError('Value object <'+valueObjects[i]
					+'> is not an instance of <'+_valueClasses[i]+'>.');
			}

			// Broadcast to the one listener.
			if (slot)
			{
				slot.execute(valueObjects);
			}
		}
		
		protected function registerListener(listener:Function, once:Boolean = false):ISlot
		{
			if (slot) 
			{
				// If the listener exits previously added, definitely don't add it.
				throw new IllegalOperationError('You cannot add or addOnce with a listener already added, remove the current listener first.');
			}
			
			return (slot = new Slot(listener, this, once));
		}

	}
}

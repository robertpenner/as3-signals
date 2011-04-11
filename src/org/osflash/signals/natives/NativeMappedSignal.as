package org.osflash.signals.natives
{
	import org.osflash.signals.SignalBindingList;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * <p>
	 * The NativeMappedSignal class is used to map/transform a native Event, 
	 * relayed from an IEventDispatcher, into other forms of data, 
	 * which are dispatched to all listeners.
	 * </p>
	 * <p>This can be used to form a border where native flash Events do not cross.</p>
	 */
	public class NativeMappedSignal extends NativeRelaySignal
	{
		/**
		 * @default is null, no mapping will occur 
		 */		
		private var _mappingFunction:Function = null;
		
		/*open for extension but closed for modifications*/
		protected function get mappingFunction ():Function 
		{
			return _mappingFunction;
		}
		
		/**
		 * Creates a new NativeMappedSignal instance to map/transform a native Event, 
	 	 * relayed from an IEventDispatcher, into other forms of data, 
	 	 * which are dispatched to all listeners.
		 * 
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param 	eventClass An optional class reference that enables an event type check in dispatch().
		 * @param	mappedTypes an optional list of types that enables the checking of the types mapped from an Event. 
		 */
		public function NativeMappedSignal(target:IEventDispatcher, eventType:String, eventClass:Class=null, ... mappedTypes)
		{
			super(target, eventType, eventClass);
			valueClasses = mappedTypes;
		}

		/**
		 * @inheritDoc
		 */
		override public function get eventClass():Class { return _eventClass; }

		override public function set eventClass(value:Class):void { _eventClass = value; }

		/**
		 * @inheritDoc
		 */
		override public function set valueClasses(value:Array):void
		{
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
		
		/**
		 * Sets the mapping function or literal object list.
		 * If the argument is a list of object literals then this list is dispatched to listeners.
		 * 
		 * <listing version="3.0">
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String).mapTo("ping")
		 *  signal.add(function(arg:String):void { trace(arg) }) // prints "ping"
		 * </listing>
		 * 
		 * And an example passing a list of literals:
		 * 
		 * <listing version="3.0">
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String, int, Number).mapTo("ping", 3, 3.1415)
		 *  signal.add(function(arg1:String, arg2:int, arg3:Number):void { trace(arg1, arg2, arg3) }) // prints "ping", 3, 3.1415
		 * </listing>
		 * 
		 * If the argument is a function then it is called when the event this NativeMappedSignal is listening for is dispatched.
		 * The function should return an Array or a single object. The data returned from the function is passed along as arguments in the Signal dispatch.
		 * Lets look at some examples of mapping functions and the function that is called back:
		 * 
		 * <listing version="3.0">
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String).mapTo(function():void { 
		 *    return "ping"
		 *  })
		 *  signal.add(function(arg:String):void { trace(arg) }) // prints "ping"
		 * </listing>
		 * 
		 * and here's an example using a list of arguments:
		 * 
		 * <listing version="3.0">
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String, int, Number).mapTo(function():void { 
		 *    return ["ping", 3, 3.1415] 
		 *  })
		 * 	signal.add(function(arg1:String, arg2:int, arg3:Number):void { trace(arg1, arg2, arg3) }) // prints "ping", 3, 3.1415
		 * </listing>
		 * 
		 * You can also state your wish to receive the native Event in th mapping function by simply including an argument of type Event:
		 * 
		 * <listing version="3.0">
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, Point).mapTo(function(event:MouseEvent):void { 
		 *    return new Point(event.localX, event.localY)
		 *  })
		 *  signal.add(function(arg:Point):void { trace(arg) }) // prints "(x=128, y=256)"
		 * </listing> 
		 * 
		 * @param objectListOrFunction This can either be a list of object literals or a function that returns list of objects. 
		 * @return The NativeMappedSignal object this method was called on. This allows the Signal to be defined and mapped in one statement.
		 */		
		public function mapTo(...objectListOrFunction):NativeMappedSignal
		{
			if (objectListOrFunction.length == 1 && objectListOrFunction[0] is Function)
			{
				_mappingFunction = objectListOrFunction[0] as Function;
				
				if (_mappingFunction.length > 1)
				{	
					throw new ArgumentError('Mapping function has ' + _mappingFunction.length 
						+ ' arguments but it needs zero or one of type Event');
				}
			}
			else
			{
				_mappingFunction = function ():Object { return objectListOrFunction; };
			}
			
			return this;
		}


		/**
		 * For usage without extension, instances of <code>NativeMappedSignal</code> that are dispatching any values ( <code>valueClasses.length > 0</code> ),
		 * needs to be provided with a either a mapping function or a list of object literals.
		 * See <code>mapTo</code> for more info.
		 * 
		 * Subclasses could override this one instead of letting the environment set the mapTo,
		 * MAKE SURE to also override <code>mapTo(...)</code> if it should not be allowed.
		 *
		 * @parameter eventFromTarget the event that was dispatched from target.
		 * @return An object or Array of objects mapped from an Event. The mapping of Event to data will be performed by the mapping function
		 * if it is set. A list of object literals can also be supplied in place of the mapping function.
		 * If no mapping function or object literals are supplied then an empty Array is returned or
		 * if <code>valueClasses.length > 0</code> an ArgumentError is thrown.
		 *
		 * @see #mapTo()
		 */
		protected function mapEvent(eventFromTarget:Event):Object
		{
			if (mappingFunction != null)
			{
				if (mappingFunction.length == 1)//todo invariant
				{
					return (mappingFunction)(eventFromTarget);
				}
				else
				{
					return mappingFunction();
				}
			} 
			else if (valueClasses.length == 0) 
			{
				return [];
			}
			
			throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses 
				+ "> but mappingFunction is null.");
		}

		override public function dispatchEvent(event:Event):Boolean
		{
			//
			//TODO: this is only required for backwards compatibility
			//
			const mappedData: Object = mapEvent(event);
			const numValueClasses:int = valueClasses.length;

			if(mappedData is Array)
			{
				const valueObjects: Array = mappedData as Array;

				var valueObject: Object;
				var valueClass: Class;

				for (var i:int = 0; i < numValueClasses; i++)
				{
					valueObject = valueObjects[i];
					valueClass = valueClasses[i];

					if (valueObject === null || valueObject is valueClass) continue;

					throw new ArgumentError('Value object <'+valueObject
						+'> is not an instance of <'+valueClass+'>.');
				}
			}
			else if(numValueClasses > 1)
			{
				throw new ArgumentError('Expected more than one value.');
			}
			else if(!(mappedData is valueClasses[0]))
			{
				throw new ArgumentError('Mapping returned '+
						getQualifiedClassName(mappedData)+', expected '+
						valueClasses[0]+'.');
			}

			return super.dispatchEvent(event);
		}

		override protected function onNativeEvent(event: Event): void
		{
			const mappedData:Object = mapEvent(event);
			// TODO: We could in theory just cache this array, so that we're not hitting the gc
			// every time we call onNativeEvent 
			const singleValue:Array = [mappedData];
			
			var bindingsToProcess:SignalBindingList = bindings;

			if (mappedData is Array)
			{
				if (valueClasses.length == 1 && valueClasses[0] == Array)//TODO invariant
				{
					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute(singleValue);
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
				else
				{
					const mappedDataArray: Array = mappedData as Array;

					while (bindingsToProcess.nonEmpty)
					{
						bindingsToProcess.head.execute(mappedDataArray);
						bindingsToProcess = bindingsToProcess.tail;
					}
				}
			}
			else
			{				
				while (bindingsToProcess.nonEmpty)
				{
					bindingsToProcess.head.execute(singleValue);
					bindingsToProcess = bindingsToProcess.tail;
				}
			}
		}
	}
}
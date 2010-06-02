package org.osflash.signals.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

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
		 * @default is initialized to flash.events.Event in constructor if omitted as parameter
		 */
		protected var _eventClass:Class;
		
		public function get eventClass ():Class 
		{
			return _eventClass;
		}
		
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
			_eventClass = eventClass || Event;
			super(target, eventType);
			setValueClasses(mappedTypes);
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
		 * If the argument is a function then it is called when the event this NativeMappedSignal is listeneing for is dispatched.
		 * The function should return an Array or a single object. The data returned from the function is passed along as arguemnts in the Signal dispatch.
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
			if (isArgumentListAFunction(objectListOrFunction))
			{
				_mappingFunction = objectListOrFunction[0] as Function;
				
				if (hasFunctionMoreThanOneArgument(_mappingFunction))
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
		
		private function isArgumentListAFunction(argList:Array):Boolean
		{
			return argList.length == 1 && argList[0] is Function;
		}
		
		private function hasFunctionMoreThanOneArgument(f:Function):Boolean
		{
			return f.length > 1;
		}
		
		/**
		 * This is used as eventHandler for target or can be called directly with the parameters specified by valueClasses.
		 * <p>If used as eventHandler the data mapping system is used to supply the super.dispatch with alternative data to dispatch.</p>
		 *
		 * @see #mapEvent()
		 * @see #mapTo()
		 * @see org.osflash.signals.NativeRelaySignal#dispatch()
		 */
		override public function dispatch (... valueObjects):void 
		{
			if (areValueObjectValidForMapping(valueObjects)) 
			{
				var mappedData:Object = mapEvent(valueObjects[0] as Event);
				dispatchMappedData(mappedData);
			} 
			else 
			{
				super.dispatch.apply(null, valueObjects);
			}
		}

		private function areValueObjectValidForMapping(valueObjects:Array):Boolean
		{
			return valueObjects.length == 1 && valueObjects[0] is _eventClass;
		}
		
		private function dispatchMappedData(mappedData:Object):void
		{
			if (mappedData is Array)
			{
				if (shouldArrayBePassedWithoutUnrolling)
				{
					super.dispatch.call(null, mappedData);
				}
				else
				{
					super.dispatch.apply(null, mappedData);
				}
			}
			else
			{
				super.dispatch.call(null, mappedData);
			}
		}
		
		private function get shouldArrayBePassedWithoutUnrolling():Boolean
		{
			return _valueClasses.length == 1 && _valueClasses[0] == Array;
		}
		
		protected function get mappingFunctionWantsEvent():Boolean
		{
			return _mappingFunction.length == 1;
		}
		
		protected function get mappingFunctionExists():Boolean
		{
			return _mappingFunction != null;
		}
		
		/**
		 * For usage without extension, instances of <code>NativeMappedSignal</code> that are dispatching any values ( <code>valueClasses.length > 0</code> ),
		 * needs to be provided with a either a mapping function or a list of object literals.
		 * See <code>mapTo</code> for more info.
		 * 
		 * Subcclasses could override this one instead of letting the environment set the mapTo,
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
		protected function mapEvent (eventFromTarget:Event):Object 
		{
			if (mappingFunctionExists) 
			{
				if (mappingFunctionWantsEvent)
				{
					return _mappingFunction(eventFromTarget);
				}
				else
				{
					return _mappingFunction();
				}
			} 
			else if (valueClasses.length == 0) 
			{
				return [];
			}
			
			throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses 
				+ "> but mappingFunction is null.");
		}
	}
}
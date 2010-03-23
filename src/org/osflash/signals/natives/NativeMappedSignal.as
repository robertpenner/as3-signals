package org.osflash.signals.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * The NativeMappedSignal class is used to map/transform an event into another type of data 
	 * that is sent along with the dispatch call as an argument.
	 * 
	 * This is used to form a border where flash native Events do not cross.
	 */
	public class NativeMappedSignal extends NativeRelaySignal
	{
		/**
		 * @default is initialized to flash.events.Event in constructor if omitted as parameter.
		 */
		protected var _eventClass:Class;
		
		public function get eventClass ():Class {
			return _eventClass;
		}
		
		private var _propertyFilterFunction:Function = null;
		
		/*open for extension but closed for modifications*/
		protected function get propertyFilterFunction ():Function {
			return _propertyFilterFunction;
		}
		
		/**
		 * Creates a new NativeMappedSignal instance to map events from an IEventDispatcher to another object.
		 * For instance each time a certain button is clicked you can translate the MouseEvent.CLICKED into a
		 * value class ButtonClicked or maybe send the name of the button.
		 * 
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param 	valueClass The Class that the eventType will be mapped to
		 * @param	mapToObjectOrFunction an object or a Function that should return an object of the same type as the valueClass argument. 
		 * If mapTo is an Object then this is what will be sent along with the signal as a value class. 
		 * If mapTo is a function the Object returned from the function is passed along as the argument with the signal. 
		 * If the mapping function can have zero or one argument. In the case of a single argument it should be of type Event. 
		 * If the mapping function does not need to know about the event then implement it with zero arguments are no Event will passed to it.  
		 */
		public function NativeMappedSignal(target:IEventDispatcher, eventType:String, eventClass:Class=null, ... propertyTypes)
		{
			/*We keep this class but it is not our valueClass.*/
			_eventClass = eventClass || Event;
			
			/*I want to use the super-contructor,
			but the implicit call of setValueClasses(Event) will only be temporarily,
			instead we want the valueClasses given as parameter in this constructor*/
			super(target, eventType);
			
			/*if valueClasses are not provided this will call the listeners with no parameter*/
			setValueClasses(propertyTypes);
		}
		
		/**
		 * @param objectOrFunction This can either be a list of object literals or a function that returns list of objects. 
		 * If the argument is a list of object literals <code>mapTo()</code>: then this list is passed along with the Signal dispatch.
		 * 
		 * Here's an example passing an object literal:
		 * 
		 * <code>
		 * 	signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String).mapTo("ping")
		 * 	signal.add(function(arg:String):void { trace(arg) }) // prints "ping"
		 * </code>
		 * 
		 * And an example passing a list of literals:
		 * 
		 * <code>
		 * 	signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String, int, Number).mapTo("ping", 3, 3.1415)
		 * 	signal.add(function(arg1:String, arg2:int, arg3:Number):void { trace(arg1, arg2, arg3) }) // prints "ping", 3, 3.1415
		 * </code>
		 * 
		 * If the argument is a function then it is called when the event this NativeMappedSignal is listeneing for is dispatched.
		 * The function should return an Array or a single object. The data returned from the function is passed along as arguemnts in the Signal dispatch.
		 * Lets look at some examples of mapping functions and the function that is called back:
		 * 
		 * <code>
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String).mapTo(function():void { 
		 * 		return "ping"
		 * 	})
		 * 	signal.add(function(arg:String):void { trace(arg) }) // prints "ping"
		 * </code>
		 * 
		 * and here's an example using a list of arguments:
		 * 
		 * <code>
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, String, int, Number).mapTo(function():void { 
		 * 		return ["ping", 3, 3.1415] 
		 * 	})
		 * 	signal.add(function(arg1:String, arg2:int, arg3:Number):void { trace(arg1, arg2, arg3) }) // prints "ping", 3, 3.1415
		 * </code>
		 * 
		 * You can also state your wish to receive the native Event in th mapping function by simply including an argument of type Event:
		 * 
		 * <code>
		 *  signal = new NativeMappedSignal(button, MouseEvent.CLICK, MouseEvent, Point).mapTo(function(event:MouseEvent):void { 
		 * 		return new Point(event.localX, event.localY)
		 * 	})
		 * 	signal.add(function(arg:Point):void { trace(arg) }) // prints "(x=128, y=256)"
		 * </code>
		 * 
		 * @return The NativeMappedSignal object this method was called on. This allows the Signal to be defined and mapped in one statement.
		 */		
		public function mapTo(...objectListOrFunction):NativeMappedSignal
		{
			if (objectListOrFunction.length == 1 && objectListOrFunction[0] is Function)
			{
				_propertyFilterFunction = objectListOrFunction[0] as Function;
				
				if (_propertyFilterFunction.length > 1)
				{	
					throw new ArgumentError('Mapping function has ' + _propertyFilterFunction.length + ' arguments but it needs zero or one of type Event');
				}
			}
			else
			{
				_propertyFilterFunction = function ():Object { return objectListOrFunction; };
			}
			
			return this
		}
		
		/**
		 * This is used as eventHandler for target or can be called directly with the parameters specified by valueClasses.
		 * <p>If used as eventHandler this uses PropertyRelaySignal's (or an extensions) property-filter-mechanism to only
		 * dispatch the required values from the Event instead of the event itself.</p>
		 *
		 * @see #filterPropertyArguments()
		 * @see #setPropertyFilterFunction()
		 * @see org.osflash.signals.NativeRelaySignal#dispatch()
		 *
		 */
		override public function dispatch (... valueObjects):void 
		{
			/*_target will call this with the dispatched Event as the only parameter*/
			if (valueObjects.length == 1 && valueObjects[0] is _eventClass) 
			{
				var mappedData:Object = filterPropertyArguments(valueObjects[0] as Event)
					
				if (mappedData is Array)
				{
					super.dispatch.apply(null, mappedData);
				}
				else
				{
					super.dispatch.call(null, mappedData);
				}
			} 
			else 
			{
				super.dispatch.apply(null, valueObjects);
			}
		}

		
		protected function get propertyFilterFunctionWantsEvent():Boolean
		{
			return _propertyFilterFunction.length == 1;
		}
		
		/**
		 * For usage without extension, instances of <code>NativeMappedSignal</code> that are dispatching any values ( <code>valueClasses.length > 0</code> ),
		 * needs to be provided with a function with the follwing syntax:
		 * <code>function [name] (event:[eventClass provided in constructor or flash.events.Event]):Array</code>
		 * See <code>setPropertyFilterFunction</code> for more infos.
		 * Subcclasses could override this one instead of letting the environment set the propertyFilterFunction,
		 * MAKE SURE to also override <code>setPropertyFilterFunction(...)</code> if it should not be allowed.
		 *
		 * @parameter eventFromTarget the event that was dispatched from target.
		 * @return An array with value gathered from <code>eventFromTarget</code>.
		 * 				The default implemetation uses <code>propertyFilterFunction</code> if it is set.
		 * 				Otherwise it returns [] if <code>valueClasses.length > 0</code> or throws an ArgumentError.
		 *
		 *
		 * @see #setPropertyFilterFunction()
		 *
		 * @internal
		 * This function gets called by dispatch to recieve the needed property-values from <code>eventFromTarget</code>.
		 * It has to return an array that matches length and types of valueClasses, wich is checked by super.dispatch.apply(null,[returned array]) afterwards.
		 * */
		protected function filterPropertyArguments (eventFromTarget:Event):Object 
		{
			if (_propertyFilterFunction != null) 
			{
				if (propertyFilterFunctionWantsEvent)
				{
					return _propertyFilterFunction(eventFromTarget);
				}
				else
				{
					return _propertyFilterFunction();
				}
			} 
			else if (valueClasses.length == 0) 
			{
				return [];
			}
			
			throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses + "> but propertyFilterFunction is null.");
		}
	}
}
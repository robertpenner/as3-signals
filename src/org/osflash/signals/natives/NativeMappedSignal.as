package org.osflash.signals.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class NativeMappedSignal extends NativeRelaySignal
	{
		private var _mapTo:Function;
		
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
		 * If mapTo is a function then the function is called each time the event is dispatched and the resulting 
		 * Object returned from the function is passed along as the argument with the signal.  
		 */
		public function NativeMappedSignal(target:IEventDispatcher, eventType:String, valueClass:Class, mapToObjectOrFunction:Object)
		{
			super(target, eventType, valueClass);
			
			if (mapToObjectOrFunction is Function)
			{
				if (mapToObjectOrFunction.length > 1)
				{	
					throw new ArgumentError('Mapping function has '+mapToObjectOrFunction.length+' arguments but it needs zero or one of type Event');
				}
				
				_mapTo = mapToObjectOrFunction as Function;
			}
			else
			{
				_mapTo = function ():Object { return mapToObjectOrFunction; };
			}
		}
		
		override public function dispatch(...valueObjects):void
		{
			validateValueObjects(valueObjects);
			var mappedData:Object = mapEventTo(valueObjects[0]);
			validateMappedData(mappedData);
			super.dispatch(mappedData);
		}
		
		private function get mapperFunctionWantsEvent():Boolean
		{
			return _mapTo.length == 1;
		}
		
		protected function validateValueObjects(valueObjects:Array):void
		{
			if (valueObjects.length != 1)
				throw new ArgumentError(valueObjects.length +' valueObjects supplied '
					+ 'The dispatch expects one value object of type Event');
			
			if (!(valueObjects[0] is Event))
				throw new ArgumentError('Value object <' + valueObjects[0]
					+ '> is not an instance of <Event>.');
		}
		
		protected function validateMappedData(mappedData:Object):void
		{
			if (!(mappedData is _valueClasses[0]))
				throw Error('mapping function returned data of type ' + Object(mappedData).constructor 
					+ ' but data of type ' + _valueClasses[0] + ' was expected'); 
		}
		
		protected function mapEventTo(event:Event):Object 
		{
			if (mapperFunctionWantsEvent)
			{
				return _mapTo.call(null, event);
			}
			else
			{
				return _mapTo();
			}
		}
	}
}
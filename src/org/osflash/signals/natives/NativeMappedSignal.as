package org.osflash.signals.natives
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class NativeMappedSignal extends NativeRelaySignal
	{
		private var _mapTo:Function
		
		/**
		 * Creates a new NativeMappedSignal instance to map events from an IEventDispatcher to another object.
		 * For instance each time a certain button is clicked you can translate the MouseEvent.CLICKED into a
		 * value class ButtonClicked or maybe send the name of the button.
		 * 
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param 	valueClass The Class that the eventType will be mapped to
		 * @param	mapTo an object or a Function that returns an Object. If mapTo is an Object then this is what 
		 * will be sent along with the signal as a value class. If mapTo is a function then the function is called each time 
		 * the event is dispatched and the resulting Object from the function is passed along with the signal.  
		 */
		public function NativeMappedSignal(target:IEventDispatcher, eventType:String, valueClass:Class, mapTo:Object)
		{
			super(target, eventType, valueClass);
			
			if (mapTo is Function)
			{
				if (mapTo.length > 1)
				{	
					throw new ArgumentError('Mapping function has '+mapTo.length+' arguments but it needs zero or one of type Event');
				}
				
				_mapTo = mapTo as Function
			}
			else
			{
				_mapTo = function ():Object { return mapTo }
			}
		}
		
		override public function dispatch(...valueObjects):void
		{
			validateValueObjects(valueObjects)	
			var mappedData:Object = map(valueObjects[0])
			super.dispatch(mappedData)
		}
		
		private function get mapperFunctionWantsEvent():Boolean
		{
			return _mapTo.length == 1
		}
		
		protected function validateValueObjects(valueObjects:Array):void
		{
			if (valueObjects.length != 1)
				throw new ArgumentError(valueObjects.length +' valueObjects supplied '
					+ 'The dispatch expects one value object of type Event');
			
			if (!valueObjects[0] is Event)
				throw new ArgumentError('Value object <' + valueObjects[0]
					+ '> is not an instance of <Event>.');
		}
		
		protected function map(event:Event):Object 
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
package org.osflash.signals.natives
{
	import flash.events.IEventDispatcher;
	
	public class NativeMappedSignal extends NativeRelaySignal
	{
		/**
		 *  
		 */		
		private var _mapTo:Function
		
		/**
		 * Creates a new NativeMappedSignal instance to map events from an IEventDispatcher to another object.
		 * For instance each time a certain button is clicked you can translate the MouseEvent.CLICKED into a
		 * value class ButtonClicked or maybe send the name of the button.
		 * 
		 * @param	target	An object that implements the flash.events.IEventDispatcher interface.
		 * @param	eventType The event string name that would normally be passed to IEventDispatcher.addEventListener().
		 * @param	mapTo an object or a Function that returns an Object. If mapTo is an Object then this is what 
		 * will be sent along with the signal as a value class. If mapTo is a function then the function is called each time 
		 * the event is dispatched and the resulting Object from the function is passed along with the signal.  
		 */
		public function NativeMappedSignal(target:IEventDispatcher, eventType:String, mapTo:Object)
		{
			var valueClass:Class = Object
			
			if (mapTo is Function)
			{
				_mapTo = mapTo as Function
			}
			else
			{
				_mapTo = function ():Object {
					return mapTo
				}
				valueClass = Object(mapTo).constructor
			}
				
			super(target, eventType, valueClass);
			
			if (_mapTo is Function && _mapTo.length > 1)
			{
				throw new ArgumentError('Mapping function has '+mapTo.length+' arguments but it needs zero or one of type Event');
			}
		}
		
		override public function dispatch(...valueObjects):void
		{
			var mapping:Object = _mapTo.apply(null, valueObjects) 
			super.dispatch(mapping)
		}
	}
}
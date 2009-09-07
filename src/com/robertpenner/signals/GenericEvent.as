package com.robertpenner.signals
{
	import com.robertpenner.signals.IEvent;
	
	/**
	 * @see com.robertpenner.signals.IEvent
	 * Documentation for the event interface being maintained in IEvent to avoid duplication for now.
	 */
	public class GenericEvent implements IEvent
	{
		protected var _bubbles:Boolean;
		protected var _target:*;
		protected var _currentTarget:*;
		protected var _signal:ISignal;
		
		public function GenericEvent(bubbles:Boolean = false)
		{
			_bubbles = bubbles;
		}
		
		public function get signal():ISignal { return _signal; }
		public function set signal(value:ISignal):void { _signal = value; }
		
		public function get target():* { return _target; }
		public function set target(value:*):void { _target = value; }
		
		public function get currentTarget():* { return _currentTarget; }
		public function set currentTarget(value:*):void { _currentTarget = value; }
		
		public function get bubbles():Boolean { return _bubbles; }
		public function set bubbles(value:Boolean):void	{ _bubbles = value;	}
		
		public function clone():IEvent
		{
			return new GenericEvent(_bubbles);
		}
	}
}

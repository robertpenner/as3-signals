package org.osflash.signals.events
{
	import org.osflash.signals.IPrioritySignal;

	/**
	 *
	 * @see org.osflash.signals.events.IEvent
	 * Documentation for the event interface being maintained in IEvent to avoid duplication for now.
	 */
	public class GenericEvent implements IEvent
	{
		protected var _bubbles:Boolean;
		protected var _target:Object;
		protected var _currentTarget:Object;
		protected var _signal:IPrioritySignal;
		
		public function GenericEvent(bubbles:Boolean = false)
		{
			_bubbles = bubbles;
		}
		
		/** @inheritDoc */
		public function get signal():IPrioritySignal { return _signal; }
		public function set signal(value:IPrioritySignal):void { _signal = value; }
		
		/** @inheritDoc */
		public function get target():Object { return _target; }
		public function set target(value:Object):void { _target = value; }
		
		/** @inheritDoc */
		public function get currentTarget():Object { return _currentTarget; }
		public function set currentTarget(value:Object):void { _currentTarget = value; }
		
		/** @inheritDoc */
		public function get bubbles():Boolean { return _bubbles; }
		public function set bubbles(value:Boolean):void	{ _bubbles = value;	}
		
		/** @inheritDoc */
		public function clone():IEvent
		{
			return new GenericEvent(_bubbles);
		}
	}
}

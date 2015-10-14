package org.osflash.signals.relaxed
{
	import org.osflash.signals.ISlot;

	public class RelaxedStateController
	{
		public function RelaxedStateController()
		{
		}
		
		private var _hasBeenDispatched : Boolean = false;
		private var _lastDispatchedValueObjects : *;

		public function get hasBeenDispatched():Boolean{
			return _hasBeenDispatched;
		}

		public function set hasBeenDispatched(value:Boolean):void{
			_hasBeenDispatched = value;
		}

		public function get dispatchedValueObjects():*{
			return _lastDispatchedValueObjects;
		}

		public function set dispatchedValueObjects(value:*):void{
			_lastDispatchedValueObjects = value;
		}

		public function handleSlot(slot:ISlot):ISlot{
			if( hasBeenDispatched ){
				slot.execute( dispatchedValueObjects );
			}
			return slot;
		}


	}
}
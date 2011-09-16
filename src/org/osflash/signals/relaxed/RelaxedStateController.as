package org.osflash.signals.relaxed
{
	import org.osflash.signals.ISlot;

	public class RelaxedStateController
	{
		public function RelaxedStateController()
		{
		}
		
		private var _hasBeenDispatched : Boolean = false;
		private var _dispatchedValueObjects : *;
		private var _slot : ISlot;

		internal function get hasBeenDispatched():Boolean{
			return _hasBeenDispatched;
		}

		internal function set hasBeenDispatched(value:Boolean):void{
			_hasBeenDispatched = value;
		}

		internal function get dispatchedValueObjects():*{
			return _dispatchedValueObjects;
		}

		internal function set dispatchedValueObjects(value:*):void{
			_dispatchedValueObjects = value;
		}

		internal function get slot():ISlot{
			return _slot;
		}

		internal function set slot(value:ISlot):void{
			_slot = value;
			if( hasBeenDispatched ){
				slot.execute( dispatchedValueObjects );
			}
		}


	}
}
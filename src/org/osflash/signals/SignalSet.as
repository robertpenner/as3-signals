package org.osflash.signals {
	import org.osflash.signals.ISignalOwner;

	/**
	 * A convenient way to access a logical set of signals.
	 * 
	 * @author Jon Adams
	 */
	public class SignalSet {

		protected var _signals:Array = [];

		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void {
			while(_signals.length) {
				var iSignalOwner:ISignalOwner = _signals.pop();
				iSignalOwner.removeAll();
			}
		}

		/**
		 * The current number of listeners for the signal.
		 */
		public function get numListeners():int {
			var count:int = 0;
			for each (var iSignalOwner : ISignalOwner in _signals) {
				count += iSignalOwner.numListeners;
			}
			return count;
		}
		
		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array {
			return _signals.concat();
		}
	}
}
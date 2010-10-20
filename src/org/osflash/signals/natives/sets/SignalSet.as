package org.osflash.signals.natives.sets {
	import org.osflash.signals.ISignalOwner;

	/**
	 * @author Jon Adams
	 */
	public class SignalSet {

		protected var signals:Array = [];

		public function removeAll():void {
			while(signals.length) {
				var iSignalOwner:ISignalOwner = signals.pop();
				iSignalOwner.removeAll();
			}
		}

		public function get numListeners():int {
			var count:int = 0;
			for each (var iSignalOwner : ISignalOwner in signals) {
				count += iSignalOwner.numListeners;
			}
			return count;
		}
	}
}

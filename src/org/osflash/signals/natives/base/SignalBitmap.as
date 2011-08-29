package org.osflash.signals.natives.base
{
	import org.osflash.signals.natives.sets.DisplayObjectSignalSet;
	import flash.display.Bitmap;

	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class SignalBitmap extends Bitmap
	{
		private var _signals:DisplayObjectSignalSet;

		public function get signals():DisplayObjectSignalSet
		{
			return _signals ||= new DisplayObjectSignalSet(this);
		}
	}
}

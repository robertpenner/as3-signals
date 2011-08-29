package org.osflash.signals.natives.base
{
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	import flash.display.Sprite;

	public class SignalSprite extends Sprite
	{
		private var _signals:InteractiveObjectSignalSet;

		public function get signals():InteractiveObjectSignalSet
		{
			return _signals ||= new InteractiveObjectSignalSet(this);
		}
	}
}
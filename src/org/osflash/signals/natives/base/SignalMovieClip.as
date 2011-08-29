package org.osflash.signals.natives.base
{
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	import flash.display.MovieClip;

	public class SignalMovieClip extends MovieClip
	{
		private var _signals:InteractiveObjectSignalSet;

		public function get signals():InteractiveObjectSignalSet
		{
			return _signals ||= new InteractiveObjectSignalSet(this);
		}
	}
}
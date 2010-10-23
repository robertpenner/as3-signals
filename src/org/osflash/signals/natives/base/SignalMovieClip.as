package org.osflash.signals.natives.base 
{
	import flash.display.MovieClip;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	
	public class SignalMovieClip extends MovieClip
	{
		private var _signals:InteractiveObjectSignalSet;
				
		public function get signals():InteractiveObjectSignalSet 
		{ 
			return _signals ||= new InteractiveObjectSignalSet(this);
		}
	}
}
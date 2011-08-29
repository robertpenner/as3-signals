package org.osflash.signals.natives.base 
{
	import flash.net.URLLoader;
	import org.osflash.signals.natives.sets.URLLoaderSignalSet;
	
	public class SignalURLLoader extends URLLoader
	{
		private var _signals:URLLoaderSignalSet;
				
		public function get signals():URLLoaderSignalSet 
		{ 
			return _signals ||= new URLLoaderSignalSet(this);
		}
	}
}
package org.osflash.signals.natives.base 
{
	import flash.net.XMLSocket;
	import org.osflash.signals.natives.sets.XMLSocketSignalSet;
	
	public class SignalXMLSocket extends XMLSocket
	{
		private var _signals:XMLSocketSignalSet;
				
		public function get signals():XMLSocketSignalSet 
		{ 
			return _signals ||= new XMLSocketSignalSet(this);
		}
	}
}
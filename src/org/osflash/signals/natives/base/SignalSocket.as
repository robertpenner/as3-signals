package org.osflash.signals.natives.base 
{
	import flash.net.Socket;
	import org.osflash.signals.natives.sets.SocketSignalSet;
	
	public class SignalSocket extends Socket
	{
		private var _signals:SocketSignalSet;
				
		public function get signals():SocketSignalSet 
		{ 
			return _signals ||= new SocketSignalSet(this);
		}
	}
}
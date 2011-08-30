package org.osflash.signals.natives.base 
{
	import flash.utils.Timer;
	import org.osflash.signals.natives.sets.TimerSignalSet;
	
	public class SignalTimer extends Timer
	{
		private var _signals:TimerSignalSet;
				
		public function get signals():TimerSignalSet 
		{ 
			return _signals ||= new TimerSignalSet(this);
		}
		
		public function SignalTimer(delay:Number, repeatCount:int = 0)
		{
			super(delay, repeatCount);
		}
	}
}
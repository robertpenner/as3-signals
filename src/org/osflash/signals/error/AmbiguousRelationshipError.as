package org.osflash.signals.error 
{

	/**
	 * The AmbiguousRelationshipError is an as3-signals specific error
	 * which is thrown if a user attempts to redefine an existing
	 * relationship between a signal and a listener method by calling
	 * first signal.add(listener) then signal.addOnce(listener) or
	 * the other way around.
	 */
	public class AmbiguousRelationshipError extends Error
	{
		
		public function AmbiguousRelationshipError(message:* = null, id:* = 0)
		{
			super(message, id);
		}
		
	}
}

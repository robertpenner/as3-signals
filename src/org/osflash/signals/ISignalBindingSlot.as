package org.osflash.signals
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface ISignalBindingSlot
	{
		
		/**
		 * Executes a listener of arity <code>0</code>.
		 */
		function execute0():void;
		
		/**
		 * Executes a listener of arity <code>1</code>.
		 * 
		 * @param value1 The argument for the listener.
		 */
		function execute1(value:Object):void;
		
		/**
		 * Executes a listener of arity <code>2</code>.
		 * 
		 * @param value1 The argument for the listener.
		 * @param value2 The argument for the listener.
		 */
		function execute2(value1:Object, value2:Object):void;
		
		/**
		 * Executes a listener of arity <code>3</code>.
		 * 
		 * @param value1 The argument for the listener.
		 * @param value2 The argument for the listener.
		 * @param value3 The argument for the listener.
		 */
		function execute3(value1:Object, value2:Object, value3:Object):void;
		
		/**
		 * Executes a listener of arity <code>n</code>.
		 * 
		 * @param args The argument for the listener.
		 */
		function execute(...args) : void;
		
		/**
		 * The listener associated with this slot binding.
		 */
		function get listener() : Function;
		function set listener(value : Function) : void;
		
		function get numArguments() : int;
	}
}

package org.osflash.signals
{
	/**
	 * The ISlot interface defines the basic properties of a
	 * listener associated with a Signal.
	 *
	 * @author Joa Ebert
	 * @author Robert Penner
	 */
	public interface ISlot
	{
		/**
		 * The listener associated with this slot.
		 */
		function get listener():Function;
		function set listener(value:Function):void;
		
		/**
		 * Allows the ISlot to inject parameters when dispatching. The params will be at 
		 * the tail of the arguments and the ISignal arguments will be at the head.
		 * 
		 * var signal:ISignal = new Signal(String);
		 * signal.add(handler).params = [42];
		 * signal.dispatch('The Answer');
		 * function handler(name:String, num:int):void{}
		 */
		function get params():Array;
		function set params(value:Array):void;

		/**
		 * Whether this slot is automatically removed after it has been used once.
		 */
		function get once():Boolean;

		/**
		 * The priority of this slot should be given in the execution order.
		 * An IPrioritySignal will call higher numbers before lower ones.
		 * Defaults to 0.
		 */
		function get priority():int;
		
		/**
		 * Whether the listener is called on execution. Defaults to true.
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		/**
		 * Executes a listener without arguments.
		 * Existing <code>params</code> are appended before the listener is called.
		 */
		function execute0():void;		

		/**
		 * Dispatches one argument to a listener.
		 * Existing <code>params</code> are appended before the listener is called.
		 * @param value The argument for the listener.
		 */
		function execute1(value:Object):void;		

		/**
		 * Executes a listener of arity <code>n</code> where <code>n</code> is
		 * <code>valueObjects.length</code>.
		 * Existing <code>params</code> are appended before the listener is called.
		 * @param valueObjects The array of arguments to be applied to the listener.
		 */
		function execute(valueObjects:Array):void;
		
		/**
		 * Removes the slot from its signal.
		 */
		function remove():void;
	}
}

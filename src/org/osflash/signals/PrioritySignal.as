/**
 * Created by IntelliJ IDEA.
 * User: revisual.co.uk
 * Date: 19/04/11
 * Time: 23:44
 * To change this template use File | Settings | File Templates.
 */
package org.osflash.signals {
public class PrioritySignal extends Signal implements IPrioritySignal {

    public function PrioritySignal( ...valueClasses ) {

        // Cannot use super.apply(null, valueClasses), so allow the subclass to call super(valueClasses).
        valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;

        super( valueClasses );
    }

    /** @inheritDoc */
    public function addWithPriority( listener:Function, priority:int = 0 ):ISignalBinding {
        return registerListenerWithPriority( listener, false, priority );
    }

    /** @inheritDoc */
    public function addOnceWithPriority( listener:Function, priority:int = 0 ):ISignalBinding {
        return registerListenerWithPriority( listener, true, priority );
    }

    override protected function registerListener( listener:Function, once:Boolean = false ):ISignalBinding {
        return registerListenerWithPriority( listener, once );
    }

    protected function registerListenerWithPriority( listener:Function, once:Boolean = false, priority:int = 0 ):ISignalBinding {
        if ( registrationPossible( listener, once ) ) {
            const binding:ISignalBinding = new SignalBinding( listener, this, once, priority );
            bindings = bindings.insertWithPriority( binding );
            return binding;
        }
        return bindings.find( listener );
    }

}
}

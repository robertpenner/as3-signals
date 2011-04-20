package org.osflash.signals {
import asunit.asserts.assertEquals;

public class PrioritySignalTest extends ISignalTestBase {

    private var prioritySignal:IPrioritySignal;
    private var gotListenerPriorities:Array;

    [Before]
    public function setUp():void {
        gotListenerPriorities = [];
        prioritySignal = new PrioritySignal();
        signal = prioritySignal;
    }

    [After]
    override public function destroySignal():void {
        gotListenerPriorities = null;
        prioritySignal.removeAll();
        prioritySignal = null;
        signal = null;
    }


    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_1():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, 3 );
        prioritySignal.addWithPriority( listenerB, 2 );
        prioritySignal.addWithPriority( listenerC, 1 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_2():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, 3 );
        prioritySignal.addWithPriority( listenerC, 1 );
        prioritySignal.addWithPriority( listenerB, 2 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_3():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, 2 );
        prioritySignal.addWithPriority( listenerA, 3 );
        prioritySignal.addWithPriority( listenerC, 1 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_4():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, 2 );
        prioritySignal.addWithPriority( listenerA, 3 );
        prioritySignal.addWithPriority( listenerC, 1 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_5():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, 1 );
        prioritySignal.addWithPriority( listenerA, 3 );
        prioritySignal.addWithPriority( listenerB, 2 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_6():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, 1 );
        prioritySignal.addWithPriority( listenerB, 2 );
        prioritySignal.addWithPriority( listenerA, 3 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );

    }


    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_1():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, 20 );
        prioritySignal.addWithPriority( listenerB, 10 );
        prioritySignal.addWithPriority( listenerC, 5 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_2():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, 20 );
        prioritySignal.addWithPriority( listenerC, 5 );
        prioritySignal.addWithPriority( listenerB, 10 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_3():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, 10 );
        prioritySignal.addWithPriority( listenerA, 20 );
        prioritySignal.addWithPriority( listenerC, 5 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_4():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, 10 );
        prioritySignal.addWithPriority( listenerC, 5 );
        prioritySignal.addWithPriority( listenerA, 20 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_5():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, 5 );
        prioritySignal.addWithPriority( listenerA, 20 );
        prioritySignal.addWithPriority( listenerB, 10 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_unconsecutive_6():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, 5 );
        prioritySignal.addWithPriority( listenerB, 10 );
        prioritySignal.addWithPriority( listenerA, 20 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_1():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, -1 );
        prioritySignal.addWithPriority( listenerB, -2 );
        prioritySignal.addWithPriority( listenerC, -3 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }


    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_2():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerA, -1 );
        prioritySignal.addWithPriority( listenerC, -3 );
        prioritySignal.addWithPriority( listenerB, -2 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_3():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, -2 );
        prioritySignal.addWithPriority( listenerA, -1 );
        prioritySignal.addWithPriority( listenerC, -3 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_4():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerB, -2 );
        prioritySignal.addWithPriority( listenerC, -3 );
        prioritySignal.addWithPriority( listenerA, -1 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_5():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, -3 );
        prioritySignal.addWithPriority( listenerA, -1 );
        prioritySignal.addWithPriority( listenerB, -2 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }

    [Test]
    public function listeners_added_with_higher_priority_should_be_called_first_independant_of_added_order_even_if_negative_6():void {

        const expectedListenerPriorities:Array = [A,B,C];

        prioritySignal.addWithPriority( listenerC, -3 );
        prioritySignal.addWithPriority( listenerB, -2 );
        prioritySignal.addWithPriority( listenerA, -1 );

        prioritySignal.dispatch();

        assertArrayEqual( expectedListenerPriorities, gotListenerPriorities );
    }


    private function listenerA():void {
        gotListenerPriorities.push( A );
    }

    private function listenerB():void {
        gotListenerPriorities.push( B );
    }

    private function listenerC():void {
        gotListenerPriorities.push( C );
    }

    private function assertArrayEqual( expected:Array, got:Array ):void {
        assertEquals( "array length unequal", expected.length, got.length );
        for ( var i:int = 0; i < gotListenerPriorities.length; i++ ) {
            assertEquals( "@i=" + i, expected[i], got[i] );
        }
    }


    private static const A:String = "A";
    private static const B:String = "B";
    private static const C:String = "C";
    private static const D:String = "D";
    private static const E:String = "E";
}
}

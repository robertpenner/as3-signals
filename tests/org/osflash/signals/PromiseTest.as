package org.osflash.signals
{
    import org.hamcrest.assertThat;
    import org.hamcrest.object.isTrue;
    import org.hamcrest.object.sameInstance;

    public class PromiseTest
    {
        private var promise:Promise;

        [Before]
        public function before():void
        {
            promise = new Promise();
        }

        [Test]
        public function addOncedListenerWillExecuteWhenPromiseIsDispatched():void
        {
            var isCalled:Boolean = false;
            function listener():void
            {
                isCalled = true;
            }

            promise.addOnce(listener);
            promise.dispatch();

            assertThat(isCalled, isTrue());
        }

        [Test]
        public function addOncedListenerWillReceiveDataWhenPromiseIsDispatched():void
        {
            var received:Object;
            function listener(data:Object):void
            {
                received = data;
            }

            var object:Object = {hello:"world"};
            promise.addOnce(listener);
            promise.dispatch(object);

            assertThat(received, sameInstance(object));
        }

        [Test]
        public function listenerWillExecuteWhenBoundAfterPromiseIsDispatched():void
        {
            var isCalled:Boolean = false;
            function listener():void
            {
                isCalled = true;
            }

            promise.dispatch();
            promise.addOnce(listener);

            assertThat(isCalled, isTrue());
        }

        [Test]
        public function listenerWillReceiveDataWhenBoundAfterPromiseIsDispatched():void
        {
            var received:Object;
            function listener(data:Object):void
            {
                received = data;
            }

            var object:Object = {hello:"world"};
            promise.dispatch(object);
            promise.addOnce(listener);

            assertThat(received, sameInstance(object));
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function promiseWillThrowErrorIfDispatchedTwice():void
        {
            promise.dispatch();
            promise.dispatch();
        }
    }
}

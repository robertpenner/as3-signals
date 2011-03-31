package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class SignalDispatchArgsTest
	{
	    [Inject]
	    public var async:IAsync;

		public var completed:Signal;

		[Before]
		public function setUp():void
		{
			completed = new Signal();
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}

		[Test]
		public function dispatch_two_correct_value_objects_should_succeed():void
		{
			var signal:Signal = new Signal(String, uint);
			signal.dispatch("the Answer", 42);
		}

		[Test(expects="ArgumentError")]
		public function dispatch_fewer_value_objects_than_value_classes_should_should_throw_ArgumentError():void
		{
			var signal:Signal = new Signal(Date, Array);
			signal.dispatch(new Date());
		}

		[Test]
		public function dispatch_more_value_objects_than_value_classes_should_succeed():void
		{
			var signal:Signal = new Signal(Date, Array);
			signal.dispatch(new Date(), new Array(), "extra value object");
		}

		[Test]
		public function dispatch_values_with_no_value_classes_defined_should_pass_to_listener():void
		{
			var signalNoValueClasses:Signal = new Signal();
			signalNoValueClasses.add( async.add(checkDispatchedValues, 10) );
			signalNoValueClasses.dispatch(22, 'done', new Date());
		}

		private function checkDispatchedValues(a:uint, b:String, c:Date):void
		{
			assertEquals('correct number of arguments were dispatched', 3, arguments.length);
			assertEquals('the uint was dispatched', 22, a);
			assertEquals('the String was dispatched', 'done', b);
			assertTrue('a Date was dispatched', c is Date);
		}

		[Test(expects="ArgumentError")]
		public function dispatch_one_correct_and_one_incorrect_value_object_should_throw_ArgumentError():void
		{
			var signal:Signal = new Signal(Date, Array);
			signal.dispatch(new Date(), "wrong value type");
		}

		[Test]
		public function dispatch_more_value_objects_than_listener_args () :void
		{
			var signal:Signal = new Signal(String, String);
			var beforeTrimSecondArgReceived:String;
			var trimmedArgReceived:String;
			var afterTrimSecondArgReceived:String;
			signal.add(function (oneArg:String, twoArg:String):void {
				assertEquals("second", twoArg);
			});
			signal.add(function (oneArg:String):void {
				assertEquals("first", oneArg);
			});
			signal.add(function (oneArg:String, twoArg:String):void {
				assertEquals("second", twoArg);
			});
			signal.add(function (...args) :void{ assertEquals(0, args.length); });
			signal.dispatch("first", "second");
		}
	}
}

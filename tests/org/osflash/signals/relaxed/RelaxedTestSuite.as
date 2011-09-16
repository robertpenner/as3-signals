package org.osflash.signals.relaxed
{
	import org.osflash.signals.relaxed.natives.RelaxedNativeMappedSignalTest;
	import org.osflash.signals.relaxed.natives.RelaxedNativeRelaySignalTest;
	import org.osflash.signals.relaxed.natives.RelaxedNativeSignalTest;

	[Suite]
	public class RelaxedTestSuite
	{
		public var _RelaxedOnceSignalTest : RelaxedOnceSignalTest;
		public var _RelaxedDeluxeSignalTest : RelaxedDeluxeSignalTest;
		public var _RelaxedMonoSignalTest : RelaxedMonoSignalTest;
		public var _RelaxedPrioritySignalTest : RelaxedPrioritySignalTest;
		public var _RelaxedSignalTest : RelaxedSignalTest;
		public var _RelaxedNativeMappedSignalTest : RelaxedNativeMappedSignalTest;
		public var _RelaxedNativeRelaySignalTest : RelaxedNativeRelaySignalTest;
		public var _RelaxedNativeSignalTest : RelaxedNativeSignalTest;
	}
}
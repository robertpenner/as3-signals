package org.osflash.signals 
{
	import asunit.framework.TestCase;

	public class AmbiguousRelationshipTest extends TestCase
	{
		private var target:Object;
		
		private var instance:ISignal;

		override protected function setUp():void
		{
			target = {};
			instance = new Signal(target);
		}

		override protected function tearDown():void
		{
			instance = null;
		}
		
		public function test_add_then_addonce_throws_error():void
		{
			var throwsError:Boolean = false;
			
			instance.add(listener);
			
			try
			{
				instance.addOnce(listener);
			}
			catch (err:Error)
			{
				throwsError = true;
			}
			finally
			{
				assertTrue("an error is thrown if you call addOnce after calling add with same listener without first removing listener", throwsError);
			}
		}
		
		public function test_addonce_then_add_throws_error():void
		{
			var throwsError:Boolean = false;
			
			instance.addOnce(listener);
			
			try
			{
				instance.add(listener);
			}
			catch (err:Error)
			{
				throwsError = true;
			}
			finally
			{
				assertTrue("an error is thrown if you call add after calling addOnce with same listener without first removing listener", throwsError);
			}
		}
		
		public function test_add_then_add_doesnt_throw_error():void
		{
			var throwsError:Boolean = false;
			
			instance.add(listener);
			
			try
			{				instance.add(listener);
			}
			catch (err:Error)
			{
				throwsError = true;
			}
			finally
			{
				assertFalse("adding a listener then adding again should not throw an error", throwsError);
			}
		}
		
		public function test_addonce_then_addonce_doesnt_throw_error():void
		{
			var throwsError:Boolean = false;
			
			instance.addOnce(listener);
			
			try
			{
				instance.addOnce(listener);
			}
			catch (err:Error)
			{
				throwsError = true;
			}
			finally
			{
				assertFalse("adding a listener then adding again should not throw an error", throwsError);
			}
		}
		
		private function listener():void
		{
			fail("if this listener is called, something horrible is going on");
		}
		
	}
}

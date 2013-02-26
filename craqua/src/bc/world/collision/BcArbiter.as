package bc.world.collision 
{

	/**
	 * @author Elias Ku
	 */
	public class BcArbiter 
	{
		private static const MAX_CONTACTS:uint = 100;
		
		public var contacts:Vector.<BcContact> = new Vector.<BcContact>(MAX_CONTACTS, true);
		public var contactCount:uint;
		
		public var object:BcGridObject;
		public var tester:BcGridObject;
		
		public function BcArbiter()
		{
			var i:uint;
			while(i<MAX_CONTACTS)
			{
				contacts[i] = new BcContact(); 
				++i;
			}
		}
		
		public function clear():void
		{
			contactCount = 0;
		}
		
		public function release():void
		{
			var i:uint;
			while(i<MAX_CONTACTS)
			{
				contacts[i].object = null;
				contacts[i].tester = null; 
				++i;
			}
		}

		/**
		 * Выделить новый контакт
		 */
		public function inject():BcContact
		{
			var contact:BcContact = contacts[contactCount];
			
			contact.object = object;
			contact.tester = tester;
			
			++contactCount;
			
			return contact;
		}
		
	}
}

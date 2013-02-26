package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcContact 
	{
		public var object:BcGridObject;
		public var tester:BcGridObject;
		
		public var point:Vector2 = new Vector2();
		public var distance:Number = 0;
		public var normal:Vector2 = new Vector2();
		public var penetration:Vector2 = new Vector2();
		
		public var next:BcContact;
		
		public function BcContact()
		{
			
		}
	}
}


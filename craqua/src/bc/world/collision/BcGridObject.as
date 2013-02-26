package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcGridObject 
	{
		// Список ячеек, которые пересекаются объектом
		public var cells:Vector.<BcGridCell> = new Vector.<BcGridCell>();
		
		// Маска коллизий
		public var mask:uint;
		
		internal var tested:Boolean;
		internal var colMin:int = -1;
		internal var colMax:int = -1;
		internal var rowMin:int = -1;
		internal var rowMax:int = -1;
		
		public var shape:BcShape;
		
		public var position:Vector2 = new Vector2();
		
		public var gridLookingNext:BcGridObject;
		public var gridLooking:Boolean;
		
		public function BcGridObject()
		{
			
		}
	}
}

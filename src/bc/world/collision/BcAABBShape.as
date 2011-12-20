package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcAABBShape extends BcShape 
	{
		// Высота и ширина
		public var width:Number;
		public var height:Number;
		
		public function BcAABBShape(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super(BcShape.SHAPE_AABB, x, y);
			
			this.width = width;
			this.height = height;
		}
		
		public override function update(position:Vector2):void
		{
			super.update(position);
			
			const w:Number = width * 0.5;
			const h:Number = height * 0.5;
			const wx:Number = worldPosition.x;
			const wy:Number = worldPosition.y;
			
			xmin = wx - w;
			ymin = wy - h;
			xmax = wx + w;
			ymax = wy + h;
		}
	}
}

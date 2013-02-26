package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcCircleShape extends BcShape 
	{
		public var radius:Number;
		
		public function BcCircleShape(x:Number = 0, y:Number = 0, radius:Number = 0)
		{
			super(SHAPE_CIRCLE, x, y);
			
			this.radius = radius;
		}
		
		public override function update(position:Vector2):void
		{
			super.update(position);
			
			const s:Number = radius;
			const wx:Number = worldPosition.x;
			const wy:Number = worldPosition.y;
			
			xmin = wx - s;
			ymin = wy - s;
			xmax = wx + s;
			ymax = wy + s;
		}
	}
}

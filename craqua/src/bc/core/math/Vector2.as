package bc.core.math 
{

	/**
	 * @author Elias Ku
	 */
	public class Vector2 
	{
		public var x:Number;
		public var y:Number;
		
		public function Vector2(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function copy(vector:Vector2):void
		{
			x = vector.x;
			y = vector.y;
		}
		
		public function assign(x:Number = 0, y:Number = 0):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setZero():void
		{
			x = 0;
			y = 0;
		}
		
		public function multScalar(value:Number):void
		{
			x *= value;
			y *= value;
		}
		
		public function addVector(vector:Vector2):void
		{
			x += vector.x;
			y += vector.y;
		}
		
		public function normalize():Number
		{
			var len:Number = Math.sqrt(x*x + y*y);
			
			if(len<0.00001)
			{
				len = 0;
				x = 0;
				y = 0;
			}
			else
			{
				const invlen:Number = 1/len;
				x*=invlen;
				y*=invlen;
			}
			
			return len;
		}
		
		public function length():Number
		{
			return Math.sqrt(x*x + y*y);
		}
		
		public function lengthSqr():Number
		{
			return x*x + y*y;
		}
		
		public function distance(point:Vector2):Number
		{
			const dx:Number = point.x - x;
			const dy:Number = point.y - y;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public function distanceSqr(point:Vector2):Number
		{
			const dx:Number = point.x - x;
			const dy:Number = point.y - y;
			return dx*dx + dy*dy;
		}
		
		public function lerp(to:Vector2, t:Number):void
		{
			x += (to.x - x)*t;
			y += (to.y - y)*t;
		}

		
	}
}

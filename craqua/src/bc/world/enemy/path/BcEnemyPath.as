package bc.world.enemy.path 
{
	import bc.core.math.BcFloatInterval;
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyPath 
	{
		public var enabled:Boolean;
		
		public var baseVelocity:Vector2 = new Vector2();
		
		public var circleA:Number = 0; 
		public var circleB:Number = 0;
		public var circleSpeed:Number = 0;
		public var circleF:Number = 0;
		
		public var flipped:Boolean;
		
		public static var VELOCITY:Vector2 = new Vector2();
		
		public function BcEnemyPath()
		{
			
		}
		
		public function setup(data:BcEnemyPathData):void
		{
			if(data)
			{
				const toRad:Number = Math.PI/180;
				var baseSpeed:Number = data.baseSpeed.getValue();
				var baseAngle:Number = data.baseAngle.getValue() * toRad;
				
				baseVelocity.x = baseSpeed * Math.cos(baseAngle);
				baseVelocity.y = baseSpeed * Math.sin(baseAngle);
				
				if(data.baseFlipping)
				{
					//baseVelocity.x = -baseVelocity.x;
				}
				
				if(data.circleSpeed)
				{
					circleSpeed = data.circleSpeed.getValue() * toRad;
					circleA = data.circleA.getValue();
					circleB = data.circleB.getValue();
					circleF = data.circleF.getValue();
				}
				else
				{
					circleSpeed = 0;
				}
				
				enabled = true;
			}
			else
			{
				enabled = false;
			}
		}

		public function calculateVelocity(time:Number, velocity:Vector2, moving:Number):void
		{
			var f:Number;
			
			velocity.x = baseVelocity.x;
			velocity.y = baseVelocity.y;
			
			if(circleSpeed != 0)
			{
				f = circleF + circleSpeed*time;
				velocity.x += -circleA*circleSpeed*Math.sin(f);
				velocity.y += circleB*circleSpeed*Math.cos(f);
			}
			
			if(flipped)
			{
				velocity.x = -velocity.x;
			}
			
			velocity.x *= moving;
			velocity.y *= moving;
		}
	}
}

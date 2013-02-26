package bc.world.enemy.path 
{
	import flash.utils.Dictionary;
	import bc.core.util.BcStringUtil;
	import bc.core.math.BcFloatInterval;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcModelData;
	import bc.core.math.Vector2;
	import bc.core.motion.BcAnimationData;
	import bc.world.collision.BcShape;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyPathData implements BcIObjectData 
	{
		public var baseSpeed:BcFloatInterval = new BcFloatInterval(100);
		public var baseAngle:BcFloatInterval = new BcFloatInterval(90);
		public var baseFlipping:Boolean = true;
		
		public var circleA:BcFloatInterval;
		public var circleB:BcFloatInterval;
		public var circleSpeed:BcFloatInterval;
		public var circleF:BcFloatInterval;
		
		public function BcEnemyPathData()
		{
			
		}
		
		public function parse(xml:XML):void
		{			
			var node:XML;
			
			if(xml.hasOwnProperty("@speed"))
			{
				BcStringUtil.parseFloatInterval(xml.@speed, baseSpeed);
			}
			
			if(xml.hasOwnProperty("@angle"))
			{
				BcStringUtil.parseFloatInterval(xml.@angle, baseAngle);
			}
			
			if(xml.hasOwnProperty("@flip"))
			{
				baseFlipping = BcStringUtil.parseBoolean(xml.@flip);
			}
			
			node = xml.circle[0];
			if(node)
			{
				circleA = BcStringUtil.parseFloatInterval(node.@a);
				circleB = BcStringUtil.parseFloatInterval(node.@b);
				circleSpeed = BcStringUtil.parseFloatInterval(node.@speed);
				circleF = BcStringUtil.parseFloatInterval(node.@f);
			}
		}
		
				
		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("enemy_path", new BcEnemyPathDataCreator(), data);
		}
		
		public static function getData(id:String):BcEnemyPathData
		{
			return BcEnemyPathData(data[id]);
		}
	}
}

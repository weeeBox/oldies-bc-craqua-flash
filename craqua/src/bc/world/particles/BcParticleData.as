package bc.world.particles 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcSheetData;
	import bc.core.display.BcBitmapData;
	import bc.core.math.BcFloatInterval;
	import bc.core.util.BcStringUtil;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcParticleData implements BcIObjectData
	{
		public var bitmap:BcBitmapData;
		public var animation:BcSheetData;

		public var friction:Number = 0;
		public var gravity:Number = 0;
		
		public var lifeTime:BcFloatInterval = new BcFloatInterval();
		public var velocity:BcFloatInterval = new BcFloatInterval();

		public var scaleBegin:BcFloatInterval = new BcFloatInterval(1);
		public var scaleEnd:BcFloatInterval = new BcFloatInterval(1);
		
		public var alphaBegin:BcFloatInterval = new BcFloatInterval(1);
		public var alphaEnd:BcFloatInterval = new BcFloatInterval(1);

		public var oriented:Boolean;		
		public var angle:BcFloatInterval = new BcFloatInterval();
		public var rotation:BcFloatInterval = new BcFloatInterval();

		public function BcParticleData()
		{
		}
			
		public function parse(xml:XML):void
		{
			var node:XML;
						
			node = xml.properties[0];
			if(node)
			{
				if(node.hasOwnProperty("@gravity"))
				{
					gravity = node.@gravity;
				}
				
				if(node.hasOwnProperty("@friction"))
				{
					friction = node.@friction;
				}
				
				if(node.hasOwnProperty("@velocity"))
				{
					velocity = BcStringUtil.parseFloatInterval(node.@velocity, velocity);
				}
				
				if(node.hasOwnProperty("@time"))
				{
					lifeTime = BcStringUtil.parseFloatInterval(node.@time, lifeTime);
				}
			}
			
			node = xml.scale[0];
			if(node)
			{
				if(node.hasOwnProperty("@begin"))
				{
					scaleBegin = BcStringUtil.parseFloatInterval(node.@begin, scaleBegin);
				}
				if(node.hasOwnProperty("@end"))
				{
					scaleEnd = BcStringUtil.parseFloatInterval(node.@end, scaleEnd);
				}
			}
			
			node = xml.alpha[0];
			if(node)
			{
				if(node.hasOwnProperty("@begin"))
				{
					alphaBegin = BcStringUtil.parseFloatInterval(node.@begin, alphaBegin);
				}
				if(node.hasOwnProperty("@end"))
				{
					alphaEnd = BcStringUtil.parseFloatInterval(node.@end, alphaEnd);
				}
			}
			
			node = xml.rotation[0];
			if(node)
			{
				if(node.hasOwnProperty("@angle"))
				{
					angle = BcStringUtil.parseFloatInterval(node.@angle, angle);
				}
				if(node.hasOwnProperty("@speed"))
				{
					rotation = BcStringUtil.parseFloatInterval(node.@speed, rotation);
				}
				if(node.hasOwnProperty("@oriented"))
				{
					oriented = BcStringUtil.parseBoolean(node.@oriented);
				}
			}
			
			if(xml.hasOwnProperty("@bitmap"))
			{
				bitmap = BcBitmapData.getData(xml.@bitmap);
			}
			else if(xml.hasOwnProperty("@animation"))
			{
				animation = BcSheetData.getData(xml.@animation);
			}
		}		
		

		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("particle", new BcParticleDataCreator(), data);
		}
		
		public static function getData(id:String):BcParticleData
		{
			return BcParticleData(data[id]);
		}
	}
}

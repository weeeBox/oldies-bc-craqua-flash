package bc.core.motion 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;

	/**
	 * @author Elias Ku
	 */
	public class BcAnimationData implements BcIObjectData 
	{
		public var motions:Vector.<BcMotionData> = new Vector.<BcMotionData>();
		public var lookup:Object = new Object();
		
		public function parse(xml:XML):void
		{
			var motionData:BcMotionData;			
			for each (var node:XML in xml.motion)
			{
				if(node.hasOwnProperty("@data"))
				{
					motionData = BcMotionData.getData(node.@data);
				}
				else
				{
					motionData = new BcMotionData();
					motionData.parse(node);
				}
				
				if(node.hasOwnProperty("@id"))
				{
					lookup[node.@id.toString()] = motionData;
				}
				
				motions.push(motionData);
			}
		}
		
		
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("animation", new BcAnimationDataCreator(), data);
		}
		
		public static function getData(id:String):BcAnimationData
		{
			return BcAnimationData(data[id]);
		}
	}
}

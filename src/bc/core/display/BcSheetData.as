package bc.core.display 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.util.BcStringUtil;

	/**
	 * @author Elias Ku
	 */
	public class BcSheetData implements BcIObjectData
	{
		public var frames:Vector.<BcBitmapData> = new Vector.<BcBitmapData>();
		public var timeline:Vector.<Number> = new Vector.<Number>();
		
		public var totalTime:Number = 0;
		public var framesCount:uint;
		
		public var loop:Boolean;
		
		public function BcSheetData()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var node:XML;
			var propertiesNode:XML;
			
			var bitmapProperties:BcBitmapData;
			var speed:Number = 1;
			var frameTime:Number;
			
			node = xml.properties[0];
			if(node)
			{
				propertiesNode = node;
				
				if(node.hasOwnProperty("loop"))
				{
					loop = BcStringUtil.parseBoolean(node.@loop);
				}
				
				if(node.hasOwnProperty("speed"))
				{
					speed = node.@speed;
				}
			}
			
			for each (node in xml.frame)
			{
				if(node.hasOwnProperty("@time"))
				{
					bitmapProperties = new BcBitmapData();
					if(propertiesNode)
					{
						bitmapProperties.parse(propertiesNode);
					}
					bitmapProperties.parse(node);
				
					frameTime = speed * Number(node.@time);
					
					frames.push(bitmapProperties);
					timeline.push(frameTime);
					
					++framesCount;
					totalTime += frameTime;
				}
			}
		}
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("sheet", BcSheetData, data);
		}
		
		public static function getData(id:String):BcSheetData
		{
			return BcSheetData(data[id]);
		}
	}
}

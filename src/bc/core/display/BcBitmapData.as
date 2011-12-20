package bc.core.display 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.device.BcAsset;
	import bc.core.math.Vector2;
	import bc.core.util.BcStringUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcBitmapData implements BcIObjectData
	{
		public var bitmapData:BitmapData;
		
		public var smoothing:Boolean = true;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var sx:Number = 1;
		public var sy:Number = 1;
		
		public var colorTransform:ColorTransform = new ColorTransform();
		
		public function BcBitmapData()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var pivot:Vector2;
			var scale:Vector2;

			if(xml.hasOwnProperty("@smoothing"))
			{
				smoothing = (xml.@smoothing.toString()=="true");
			}
			
			if(xml.hasOwnProperty("@pivot"))
			{
				pivot = BcStringUtil.parseVector2(xml.@pivot, pivot);
			}
			
			if(xml.hasOwnProperty("@scale"))
			{
				scale = BcStringUtil.parseVector2(xml.@scale, scale);
			}
			
			if(xml.hasOwnProperty("@color"))
			{
				BcStringUtil.parseColorTransform(xml.@color, colorTransform);
			}
			
			if(xml.hasOwnProperty("@data"))
			{
				bitmapData = BcAsset.getImage(xml.@data);
			}
			else if(xml.hasOwnProperty("@id"))
			{
				bitmapData = BcAsset.getImage(xml.@id);
			}
			
			if(scale)
			{
				sx = scale.x;
				sy = scale.y;
			}
			
			if(pivot)
			{
				x = -sx * pivot.x;
				y = -sy * pivot.y;
			}
		}
		
		public function setupBitmap(bitmap:Bitmap):void
		{
			bitmap.bitmapData = bitmapData;
			bitmap.smoothing = smoothing;
			bitmap.pixelSnapping = PixelSnapping.NEVER;
			bitmap.x = x;
			bitmap.y = y;
			bitmap.scaleX = sx;
			bitmap.scaleY = sy;
			bitmap.transform.colorTransform = colorTransform;
		}
		
		public function createBitmap():Bitmap
		{
			var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, smoothing);
			
			bitmap.x = x;
			bitmap.y = y;
			bitmap.scaleX = sx;
			bitmap.scaleY = sy;
			bitmap.transform.colorTransform = colorTransform;
			
			return bitmap;
		}
		
		/*private static var properties:Dictionary = new Dictionary();
		
		public static function load(xmlName:String):void
		{
			var asset:EkAsset = EkAsset.instance;
			var xml:XML = asset.getXML(xmlName);
			var props:BcBitmapData;
			for each (var node:XML in xml.bitmap)
			{
				props = new BcBitmapData();
				props.parse(node);
				properties[node.@id.toString()] = props;
			}
			asset.removeXML(xmlName);
		}
		
		public static function getData(id:String):BcBitmapData
		{
			var props:BcBitmapData = properties[id];
			return props;
		}
		
		public static function setup(bitmap:Bitmap, id:String):void
		{
			var props:BcBitmapData = properties[id];
			props.setupBitmap(bitmap);
		}
		
		public static function create(id:String):Bitmap
		{
			var props:BcBitmapData = properties[id];
			return props.createBitmap();
		}*/
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("bitmap", BcBitmapData, data);
		}
		
		public static function addData(id:String, bd:BcBitmapData):void
		{
			data[id] = bd;
		}
		
		public static function getData(id:String):BcBitmapData
		{
			return BcBitmapData(data[id]);
		}
		
		public static function setup(bitmap:Bitmap, id:String):void
		{
			getData(id).setupBitmap(bitmap);
		}
		
		public static function create(id:String):Bitmap
		{
			return getData(id).createBitmap();
		}
	}
}

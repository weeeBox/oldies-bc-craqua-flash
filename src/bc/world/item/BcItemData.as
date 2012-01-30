package bc.world.item 
{
	import bc.world.particles.BcParticleData;
	import bc.core.audio.BcSound;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcBitmapData;
	import bc.world.collision.BcShape;

	/**
	 * @author Elias Ku
	 */
	public class BcItemData implements BcIObjectData
	{
		// Шейп для пули
		public var shape:BcShape;
				
		public var bodyBitmap:BcBitmapData;
		public var backBitmap:BcBitmapData;

		public static const MONEY:uint = 0;
		public static const GEM:uint = 1;
		public static const HEAL:uint = 2;
		public static const BOMB:uint = 3;

		public var type:uint;
		public var amount:uint;
		
		public var sfxPick:BcSound;
		
		public var particle:BcParticleData;
		public var particleCount:uint;
		
		public var scale:Number = 1;
		
		public var magnitDistance:Number = 100;
		public var magnitForce:Number = 100;
		
		public var phyFriction:Number = 5;
		public var phySpeed:Number = 700;
		public var phyGravity:Number = 300;
		
		public var spining:Number = 0;
		
		
		public static var moneyList:Vector.<BcItemData> = new Vector.<BcItemData>();
		public static var gemList:Vector.<BcItemData> = new Vector.<BcItemData>();
		public static var healingItem:BcItemData; 
		public static var bombItem:BcItemData;
		
		public function BcItemData()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var node:XML;
			var typeName:String;

			shape = BcShape.createFromXML(xml.shape[0]);			
			
			if(xml.hasOwnProperty("@type"))
			{
				typeName = xml.@type.toString();
				switch(typeName)
				{
					case "money":
						type = MONEY;
						moneyList.push(this);
						break;
					case "gem":
						type = GEM;
						gemList.push(this);
						break;
					case "heal":
						type = HEAL;
						healingItem = this;
						break;
					case "bomb":
						type = BOMB;
						bombItem = this;
						break;
				}
			}
			
			if(xml.hasOwnProperty("@amount"))
			{
				amount = xml.@amount;
			}
			
			if(xml.hasOwnProperty("@spining"))
			{
				spining = xml.@spining;
			}
			
			if(xml.hasOwnProperty("@scale"))
			{
				scale = xml.@scale;
			}
			
			node = xml.particles[0];
			if(node)
			{
				particle = BcParticleData.getData(node.@data);
				particleCount = node.@count;
			}
			
			node = xml.magnit[0];
			if(node)
			{
				magnitForce = node.@force;
				magnitDistance = node.@distance;
			}
			
			node = xml.phy[0];
			if(node)
			{
				//phyFriction = node.@friction;
				//phySpeed = node.@speed;
				phyGravity = node.@gravity;
			}
			
			if(xml.hasOwnProperty("@sfx"))
			{
				sfxPick = BcSound.getData(xml.@sfx);
			}
				
			node = xml.sprite[0];
			bodyBitmap = BcBitmapData.getData(node.@body.toString());
			backBitmap = BcBitmapData.getData(node.@back.toString());
		}
		
		//////////////
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("item", BcItemData, data);
		}
		
		public static function getData(id:String):BcItemData
		{
			return BcItemData(data[id]);
		}
	}
}

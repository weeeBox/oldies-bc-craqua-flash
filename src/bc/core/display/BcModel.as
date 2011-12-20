package bc.core.display 
{
	import bc.core.util.BcSpriteUtil;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcModel extends Sprite 
	{
		public var data:BcModelData;
		public var lookup:Object;
		private var nodes:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public function BcModel(data:BcModelData = null)
		{
			if(data)
			{
				setup(data);
			}
		}
		
		public function setup(data:BcModelData):void
		{
			this.data = data;
			nodes.length = 0;
			lookup = new Object();
			
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			
			createRoot();
		}
		
		private function createRoot():void
		{
			var node:BcModelNode = data.root;
			setupSprite(this, node);
			nodes.push(this);
			lookup["root"] = this;
			
			if(node.children)
			{
				for each(var iter:BcModelNode in node.children)
				{
					createNode(iter);
				}
			}
		}
		
		private function createNode(node:BcModelNode):void
		{
			var displayObject:DisplayObject;
			var sprite:Sprite;
			var bitmap:Bitmap;
			
			if(node.bitmap)
			{
				displayObject = bitmap = new Bitmap();
				
				if(node.bitmapData)
				{
					node.bitmapData.setupBitmap(bitmap);
				}
			}
			else
			{
				displayObject = sprite = new Sprite();
				setupSprite(sprite, node);
			}
			
			DisplayObjectContainer(nodes[node.parent]).addChild(displayObject);			
			nodes.push(displayObject);
			
			if(node.id)
			{
				lookup[node.id] = displayObject;
			}
			
			if(node.children)
			{
				for each(var iter:BcModelNode in node.children)
				{
					createNode(iter);
				}
			}
		}
		
		private function setupSprite(sprite:Sprite, node:BcModelNode):void
		{
			BcSpriteUtil.setupFast(sprite);
			
			sprite.visible = node.visible;
			sprite.x = node.x;
			sprite.y = node.y;
			sprite.scaleX = node.scaleX;
			sprite.scaleY = node.scaleY;
			sprite.rotation = node.rotation;
		}
	}
}


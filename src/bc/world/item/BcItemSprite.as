package bc.world.item 
{
	import bc.core.util.BcSpriteUtil;
	import bc.world.common.BcShadowSprite;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcItemSprite extends Sprite 
	{
		private var backBitmap:Bitmap = new Bitmap();
		private var bodyBitmap:Bitmap = new Bitmap();
		private var shadow:BcShadowSprite = new BcShadowSprite();
		
		private var item:BcItem;
		
		private var lighting:Number = 0;
		private var show:Number = 0;
		
		public function BcItemSprite(item:BcItem)
		{
			BcSpriteUtil.setupFast(this);

			visible = false;
			
			this.item = item;
			
			addChild(backBitmap);
			addChild(bodyBitmap);
		}
		
		public function join(caster:DisplayObject):void
		{
			var layer:DisplayObjectContainer = item.world.mainLayer;
			var data:BcItemData = item.data;
			data.bodyBitmap.setupBitmap(bodyBitmap);
			data.backBitmap.setupBitmap(backBitmap);

			scaleX = data.scale;
			scaleY = data.scale;
			rotation = 0;
			 
			show = 0;
			
			alpha = 1;
			shadow.alpha = 1;
			
			lighting = 0;
			 
			visible = true;
			shadow.join();
			
			if(caster)
			{
				layer.addChildAt(this, layer.getChildIndex(caster)+1);
			}
			else
			{
				layer.addChildAt(this, 0);
			}
		}

		public function exit():void
		{
			parent.removeChild(this);
			shadow.exit();
			visible = false;
		}

		public function update(dt:Number):void
		{
			var sh:Number;
			var t:Number = item.time;
			if(t > 0)
			{
				t = 1-t*t*t;
				sh = t * 0.5 * (1 + (int(item.time * 20) & 1));//0.5 + 0.5*Math.sin( Math.PI*0.5 + item.time * ( 8 * Math.PI * 2 + Math.PI ) );
				shadow.alpha = alpha = sh;
			}
			
			/*if(show<1)
			{
				show += dt*6;
				if(show > 1)
					show = 1;
				scaleX = 
				scaleY = show;
			}*/
			
			lighting+=dt;
			
			backBitmap.alpha = 0.75*(0.5 + 0.5*Math.sin(lighting*10));
				
			shadow.update(x + 8, y - 16, 16);
		}
	}
}

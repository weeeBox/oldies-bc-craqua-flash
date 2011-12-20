package bc.world.common 
{
	import bc.core.display.BcBitmapData;
	import bc.core.util.BcSpriteUtil;
	import bc.game.BcGameGlobal;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcShadowSprite extends Sprite 
	{
		private var env:Sprite;
		private var bm:Bitmap;
		
		private var ground:Number;
		private var koefScale:Number;
		
		public function BcShadowSprite(ground:Number = 476)
		{
			BcSpriteUtil.setupFast(this);
			visible = false;
			
			env = BcGameGlobal.world.hud.middle;
			
			bm = BcBitmapData.create("level_shadow");
			addChild(bm);
			
			y = this.ground = ground;
			koefScale = 1 - (476 - ground)/16;
		}
		
		public function join():void
		{
			env.addChild(this);
		}
		
		public function exit():void
		{
			env.removeChild(this);
			visible = false;
		}
		
		public function update(x:Number, y:Number, size:Number):void
		{
			var a:Number = Math.abs(ground - y) / 64;
			
			if(a < 1)
			{
				if(!visible)
					visible = true;
				
				a = (1 - a)*koefScale;
				bm.alpha = a;
				scaleX = a*size/20;
				scaleY = a;
				this.x = x;
			}
			else if(a > 1 && visible)
			{
				visible = false;
			}
		}
	
	}
}

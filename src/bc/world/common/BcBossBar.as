package bc.world.common 
{
	import bc.core.device.BcAsset;
	import bc.core.util.BcSpriteUtil;
	import bc.game.BcGameGlobal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Elias Ku
	 */
	public class BcBossBar extends Sprite 
	{
		public var tf:TextField = new TextField();
		public var filter:DropShadowFilter = new DropShadowFilter(0, 0, 0x00284b, 1, 2, 2, 8, 2);
		public var bitmap:Bitmap = new Bitmap();
		
		public var back:Bitmap = new Bitmap();
		public var hp:Bitmap = new Bitmap();
	
		public var showProgress:Number = 0;
		public var showed:Boolean;
		
		public var hpProgress:Number = 1;
		public var hpFrom:Number = 0;
		public var hpTime:Number = 0;
		public var hpRect:Rectangle = new Rectangle();
		public var hpWidth:Number = 0;
		
	
		public function BcBossBar()
		{
			BcSpriteUtil.setupFast(this);
		
			var backImage:BitmapData = BcAsset.getImage("level_boss_back");
			back.bitmapData = backImage;
			hp.bitmapData = BcAsset.getImage("level_boss_hp");
			
			hp.smoothing = 
			back.smoothing = true;
			
			hp.pixelSnapping = 
			back.pixelSnapping = PixelSnapping.NEVER;
			
			hp.x = 
			back.x = -backImage.width*0.5;
			
			hp.y = 
			back.y = 28;
			
			hpRect.width = hpWidth = backImage.width;
			hpRect.height = backImage.height;
			
			hp.scrollRect = hpRect;
			
			addChild(back);
			addChild(hp);
			
        	tf.defaultTextFormat = new TextFormat("main", 18, 0xffffff);
			tf.embedFonts = true;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = 0xffffff;
			tf.filters = [filter];
			tf.cacheAsBitmap = true;
			tf.x = 4;
			
			//addChild(tf);
			bitmap.y = 2;
			addChild(bitmap);
			scaleX = 
			scaleY = 0.99;
			//cacheAsBitmap = true;
			
			visible = false;
			x = 320;
		}
		
		public function update(dt:Number):void
		{
			var updateY:Boolean;
			if(parent)
			{
				if(showed && showProgress < 1)
				{
					showProgress += dt;
					if(showProgress > 1)
					{
						showProgress = 1;
					}
					updateY = true;
				}
				else if(!showed)
				{
					showProgress -= dt;
					if(showProgress <= 0)
					{
						parent.removeChild(this);
						visible = false;
					}
					else
					{
						updateY = true;
					}
				}
				
				if(updateY)
				{
					y = easeOutCubic(showProgress, -40, 40, 1);
				}
				
				if(hpTime > 0)
				{
					hpTime -= dt*4;
					if(hpTime < 0)
					{
						hpTime = 0;
					}
					updateHP();
				}
			}
		}
		
		public function easeOutCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
		public function easeOutInCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d*0.5) return easeOutCubic (t*2, b, c*0.5, d);
			return easeInCubic((t*2)-d, b+c*0.5, c*0.5, d);
		}
		
	
		public function easeInCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*(t/=d)*t*t + b;
		}

		
		public function launch(text:String):void
		{
			tf.text = text;

			var bitmapData:BitmapData = new BitmapData(int(tf.width+5), int(tf.height+5), true, 0);
			
			bitmapData.draw(tf, tf.transform.matrix);
			bitmap.bitmapData = bitmapData;
			bitmap.smoothing = true;
			bitmap.pixelSnapping = PixelSnapping.NEVER;
			
			bitmap.x = -tf.width*0.5;
			y = -40;
			showProgress = 0;
			showed = true;
			BcGameGlobal.world.hud.middle.addChild(this);
			visible = true;
			
			initHP();
		}
		
		public function hide():void
		{
			showed = false;
		}
		
		public function exit():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
			showed = false;
			visible = false;
		}
		
		private function initHP():void
		{
			hpProgress = 1;
			hpTime = 0;
			hpRect.width = hpWidth*hpProgress;
			hp.scrollRect = hpRect;
		}
		
		private function updateHP():void
		{
			hpRect.width = hpWidth*(hpProgress + hpTime*hpTime*hpTime*(hpFrom - hpProgress) );
			hp.scrollRect = hpRect;
		}
		
		public function setHP(perc:Number = 1):void
		{
			hpFrom = hpProgress + hpTime*hpTime*hpTime*(hpFrom - hpProgress);
			hpProgress = perc;
			hpTime = 1;
			updateHP();
		}
	}
}

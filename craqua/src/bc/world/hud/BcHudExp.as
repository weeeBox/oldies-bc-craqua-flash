package bc.world.hud 
{
	import bc.core.display.BcBitmapData;
	import bc.core.motion.BcEasing;
	import bc.core.util.BcSpriteUtil;
	import bc.world.common.BcShadowSprite;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class BcHudExp extends Sprite 
	{
		private var levelupAura:Sprite = new Sprite();
		private var back:Sprite = new Sprite();
		private var full:Sprite = new Sprite();
		private var clip:Sprite = new Sprite();
		private var digits:Sprite = new Sprite();
		private var digitBitmap:Bitmap = new Bitmap();
		private var digit10Bitmap:Bitmap = new Bitmap();
		private var shadow:BcShadowSprite = new BcShadowSprite(470);
		
		private var baseY:Number = 440;

		private var flow:Number = 0;
		
		public var iconRotation:Number = 0;
		
		private var fullHeight:Number;
		private var fullRect:Rectangle = new Rectangle();
		
		private var indicatorTween:Number = 1;
		private var indicatorStart:Number = 0;
		private var indicatorValue:Number = 0;
		private var progress:Number = 0;
		
		private var digitsTween:Number = 1;
		
		private var levelupTween:Number = 0;
		private var gemTween:Number = 0;
		
		public function BcHudExp()
		{
			BcSpriteUtil.setupFast(this);
			BcSpriteUtil.setupFast(back);
			BcSpriteUtil.setupFast(full);
			BcSpriteUtil.setupFast(clip);
			BcSpriteUtil.setupFast(levelupAura);

			
			levelupAura.addChild(BcBitmapData.create("level_xp_empty"));
			back.addChild(BcBitmapData.create("level_xp_empty"));
			full.addChild(BcBitmapData.create("level_xp_full"));
			addChild(back);
			clip.addChild(full);
			addChild(clip);
			addChild(levelupAura);
			addChild(digits);
			
			
			fullHeight = 54;
			fullRect.x = -fullHeight*0.5;
			fullRect.y = -fullHeight*0.5;
			fullRect.width = 54;
			
			digits.addChild(digit10Bitmap);
			digits.addChild(digitBitmap);
			
			digits.scaleX = 0.5;
			digits.scaleY = 0.5;
			
			shadow.join();
			
			x = 320;
			y = baseY;
		}
		
		public function initialize():void
		{

		}
		
		public function update(dt:Number):void
		{
			flow += dt*0.5;
			if(flow > 1)
			{
				flow -= int(flow);
			}
			
			var a:Number = Math.sin(flow*Math.PI*2);
			const rotSpeed:Number = (1+5*gemTween*gemTween)*dt*30;
			y = baseY + a;
			
			back.rotation += rotSpeed; 
			full.rotation += rotSpeed;
				
			shadow.update(x, y, 64);
			
			if(indicatorTween<1)
			{
				indicatorTween += dt*4;
				if(indicatorTween > 1)
					indicatorTween = 1;
				indicatorValue = indicatorStart + BcEasing.sineOut.easing(indicatorTween)*(progress - indicatorStart);
				updateIndicator();
			}
			
			if(digitsTween < 1)
			{
				digitsTween += dt*2;
				if(digitsTween > 1)
					digitsTween = 1;
				var sc:Number = 1.3 - BcEasing.sineOut.easing(digitsTween)*0.55;
				digits.scaleX = sc;
				digits.scaleY = sc;
			}
			
			if(levelupTween > 0)
			{
				levelupTween -= dt;
				updateLevelup();
			}
			
			if(gemTween > 0)
			{
				gemTween -= dt;
			}
		}
		
		public function setIndicator(progress:Number):void
		{
			indicatorValue = this.progress = progress;
			indicatorTween = 1;
			updateIndicator();
		}
		
		private function updateIndicator():void
		{
			const normIndicator:Number = 0.1+indicatorValue*0.8;
			
			fullRect.height = fullHeight*normIndicator;
			fullRect.y = -fullHeight*0.5 + (1-normIndicator)*fullHeight;
			clip.scrollRect = fullRect;
			clip.x = - fullRect.width * 0.5;
			clip.y = -fullHeight*0.5 + fullHeight*(1-normIndicator);
		}
		
		public function setProgress(progress:Number):void
		{
			indicatorStart = indicatorValue;
			indicatorTween = 0;
			this.progress = progress;
			
		}
		
		public function setLevel(level:uint):void
		{
			var lvl:uint = level + 1;
			digits.visible = lvl > 1;
			if(lvl > 1)
			{
				BcDialSprite.digitBitmaps[lvl%10].setupBitmap(digitBitmap);
				
				if(lvl==10)
				{
					digit10Bitmap.visible = true;
					BcDialSprite.digitBitmaps[1].setupBitmap(digit10Bitmap);
					digit10Bitmap.x -= 8;
					digitBitmap.x += 8;
				}
				else
				{
					digit10Bitmap.visible = false;
				}
				
				digitsTween = 0;
			}
			
			levelupTween = 0;
			updateLevelup();
		}
		
		private function updateLevelup():void
		{
			var sc:Number;
			if(levelupTween > 0)
			{
				sc = levelupTween*levelupTween;
				levelupAura.scaleX = 1+(1-sc)*2;
				levelupAura.scaleY = 1+(1-sc)*2;
				levelupAura.alpha = sc;
			}
			else if(levelupAura.visible)
			{
				levelupAura.visible = false;
			}
		}
		
		public function onLevelup():void
		{
			levelupTween = 1;
			levelupAura.rotation = back.rotation;
			levelupAura.visible = true;
			updateLevelup();
		}
		
		public function onGemPick():void
		{
			gemTween = 1;
		}


	}
}

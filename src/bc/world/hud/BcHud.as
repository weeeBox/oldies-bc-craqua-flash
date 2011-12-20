package bc.world.hud 
{
	import bc.core.device.BcAsset;
	import bc.core.util.BcSpriteUtil;
	import bc.game.BcGameGlobal;
	import bc.world.core.BcWorld;
	import bc.world.particles.BcParticleData;

	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class BcHud
	{
		private var world:BcWorld;
		
		public var health:BcHudField;
		public var money:BcHudField;
		public var bombs:BcHudBombs;
		public var exp:BcHudExp;
		
		public var background:Sprite = new Sprite();
		public var middle:Sprite = new Sprite();
		public var middleZeroIndex:uint;
		//public var overlay:Sprite = new Sprite();
		
		public var debugChildrenLeaksMiddle:uint;
		
		public function BcHud()
		{	
			world = BcGameGlobal.world;
					
			BcDialSprite.initialize();
			
			BcSpriteUtil.setupFast(background);
			BcSpriteUtil.setupFast(middle);
			//BcSpriteUtil.setupFast(overlay);
		}
		
		public function initialize():void
		{
			var bitmap:Bitmap;
			
			background.addChild(bitmapBackground);
			background.addChild(bitmapBackgroundTween);
			
			bitmap = new Bitmap(BcAsset.getImage("level_stick"), PixelSnapping.NEVER, false);
			bitmap.x = 
			bitmap.y = -4;
			middle.addChild(bitmap);
			
			bitmap = new Bitmap(BcAsset.getImage("level_stick"), PixelSnapping.NEVER, false);
			bitmap.x = 640+4;
			bitmap.y = -4;
			bitmap.scaleX = -1;
			middle.addChild(bitmap);
			
			bitmapMiddle.x = bitmapMiddleTween.x = -4;
			bitmapMiddle.y = bitmapMiddleTween.y = 440-4;
			middle.addChild(bitmapMiddle);
			middle.addChild(bitmapMiddleTween);
			
			middleZeroIndex = 5;
			
			health = new BcHudField(52, 3, "level_hp");
			middle.addChild(health);
			
			money = new BcHudField(480, 6, "level_score", "level_score_decoration");
			money.iconRotation = 4;
			money.shadowRotationK = 0.3;
			money.shadowRotationOffset = 3;
			middle.addChild(money);
			
			bombs = new BcHudBombs(6, middle);
			
			exp = new BcHudExp();
			middle.addChild(exp);
			
			debugChildrenLeaksMiddle = middle.numChildren;
			
			scrapRect.width = 640;
			scrapRect.height = 470;
			dayParticleData = BcParticleData.getData("level_day");
			nightParticleData = BcParticleData.getData("level_night");
		}

		public function start():void
		{
			health.initialize();
			money.initialize();
			bombs.initialize();
			exp.initialize();
		}
		
		public function update(dt:Number):void
		{
			health.update(dt);
			money.update(dt);
			bombs.update(dt);
			exp.update(dt);
			
			if(tweenProgress < 1)
			{
				updateTween(dt);
			}
			
			if(envParticleData)
			{
				envParticles += dt * 10;
				if(envParticles >= 1)
				{
					world.particles.launchRect(envParticleData, scrapRect, 3.14/4, 3.14/6, int(envParticles), background);
					envParticles -= int(envParticles);
				}
			}
		}
		
		private var envParticles:Number = 0;
		private var envParticleData:BcParticleData;
		private var dayParticleData:BcParticleData;
		private var nightParticleData:BcParticleData;
		private var scrapRect:Rectangle = new Rectangle();
		
		
		private var bitmapBackground:Bitmap = new Bitmap();
		private var bitmapMiddle:Bitmap = new Bitmap();
		
		private var bitmapBackgroundTween:Bitmap = new Bitmap();
		private var bitmapMiddleTween:Bitmap = new Bitmap();
		
		private var tweenProgress:Number = 1;
		private var night:Boolean;
		
		public function initEnv(night:Boolean = false):void
		{
			var backImg:String;
			var middleImg:String;
			
			if(night)
			{
				backImg = "level_sea_back_night";
				middleImg = "level_bottom_night";
				envParticleData = nightParticleData;
			}
			else
			{
				backImg = "level_sea_back";
				middleImg = "level_bottom";
				envParticleData = dayParticleData;
			}
			
			bitmapBackground.bitmapData = BcAsset.getImage(backImg);
			bitmapBackground.pixelSnapping = PixelSnapping.NEVER;
			bitmapBackground.smoothing = false;
			
			bitmapMiddle.bitmapData = BcAsset.getImage(middleImg);
			bitmapMiddle.pixelSnapping = PixelSnapping.NEVER;
			bitmapMiddle.smoothing = false;
			bitmapMiddle.alpha = 1;
			
			bitmapBackgroundTween.visible = 
			bitmapMiddleTween.visible = false;
			
			tweenProgress = 1;
			
			this.night = night;
		}
		
		private function updateTween(dt:Number):void
		{
			var t:Number;
			tweenProgress += dt;
			if(tweenProgress < 1)
			{
				bitmapBackgroundTween.alpha = tweenProgress;
				
				t = tweenProgress;
				bitmapMiddle.alpha = 1-t*t*t;
				t = 1 - tweenProgress;
				bitmapMiddleTween.alpha = 1-t*t*t;
			}
			else
			{
				initEnv(night);
			}
		}
		
		public function tweenNight(night:Boolean):void
		{
			var backImg:String;
			var middleImg:String;
					
			if(this.night != night)
			{
				this.night = night;
				
				if(night)
				{
					backImg = "level_sea_back_night";
					middleImg = "level_bottom_night";
					envParticleData = nightParticleData;
				}
				else
				{
					backImg = "level_sea_back";
					middleImg = "level_bottom";
					envParticleData = dayParticleData;
				}
			
				bitmapBackgroundTween.bitmapData = BcAsset.getImage(backImg);
				bitmapBackgroundTween.pixelSnapping = PixelSnapping.NEVER;
				bitmapBackgroundTween.smoothing = false;
				
				bitmapMiddleTween.bitmapData = BcAsset.getImage(middleImg);
				bitmapMiddleTween.pixelSnapping = PixelSnapping.NEVER;
				bitmapMiddleTween.smoothing = false;
					
				bitmapBackgroundTween.visible = 
				bitmapMiddleTween.visible = true;
				
				bitmapBackgroundTween.alpha = 
				bitmapMiddleTween.alpha = 0;
				
				tweenProgress = 0;
			}
		}
	}
}

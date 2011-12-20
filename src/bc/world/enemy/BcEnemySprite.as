package bc.world.enemy 
{
	import bc.core.display.BcModel;
	import bc.core.motion.BcMotion;
	import bc.core.motion.BcMotionData;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemySprite extends BcModel 
	{
		protected var monster:BcEnemy;
		
		//protected var bodySprite:Sprite = new Sprite();
		//protected var bodyBitmap:Bitmap = new Bitmap();
		
		private var damagedEffect:Number = 0;
		private var damagedColorTransform:ColorTransform = new ColorTransform();
		
		//public var bodyAnimation:BcMotion = new BcMotion();
		
		public function BcEnemySprite(monster:BcEnemy)
		{
			//BcSpriteUtil.setupFast(this);
			//BcSpriteUtil.setupFast(bodySprite);
			visible = false;
			
			this.monster = monster;
			
			//bodySprite.addChild(bodyBitmap);

			//addChild(bodySprite);
			
			//bodyAnimation.target = bodySprite;
			//bodyAnimation.setup(BcMotionData.getData("soul_body"));
		}

		public function initialize():void
		{
			//monster.properties.bitmapBody.setupBitmap(bodyBitmap);
			//bodyAnimation.play();
		}
		
		public function update(dt:Number):void
		{
			if(damagedEffect > 0)
			{
				damagedEffect-=dt*4;
				if(damagedEffect < 0)
					damagedEffect = 0;
				
				damagedColorTransform.redOffset = 
				damagedColorTransform.greenOffset = 
				damagedColorTransform.blueOffset = damagedEffect*255;
				transform.colorTransform = damagedColorTransform;
			}
			
			//bodyAnimation.update(dt);
		}
		
		public function onDamage():void
		{
			damagedEffect = monster.data.hitLight;
		}
	}
}

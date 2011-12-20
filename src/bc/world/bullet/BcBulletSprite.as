package bc.world.bullet 
{
	import bc.core.util.BcSpriteUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcBulletSprite extends Sprite 
	{
		// Какую пулю рисуем
		public var bullet:BcBullet;
		public var data:BcBulletData;
		
		public var bodyBitmap:Bitmap = new Bitmap();
		
		public var pulseCounter:Number = 0;
				
		public function BcBulletSprite(bullet:BcBullet)
		{	
			BcSpriteUtil.setupFast(this);
			
			this.bullet = bullet;			
			
			addChild(bodyBitmap);
		}
		
		public function onAdd():void
		{
			if(data!=bullet.data)
			{
				data = bullet.data;
				data.bodyBitmap.setupBitmap(bodyBitmap);
			}
			
			if(data.bodyOriented)
			{
				rotation = 180 * Math.atan2(bullet.velocity.y, bullet.velocity.x) / Math.PI;
			}
			else
			{
				rotation = 0;
			}
			
			if(data.pulseW > 0)
			{
				pulseCounter = 0;
				updatePulse();
			}
			else
			{
				scaleX = 
				scaleY = 1;
			}
		}

		public function update(dt:Number):void
		{
			var dx:Number;
			var dy:Number;
			
			if(data.bodyOriented)
			{
				dx = bullet.impulse.x + bullet.velocity.x;
				dy = bullet.impulse.y + bullet.velocity.y;
				rotation = 180 * Math.atan2(dy, dx) / Math.PI;
			}
			else
			{
				if(data.bodyRotation!=0)
				{
					rotation += dt * data.bodyRotation;
				}
			}
			
			if(data.pulseW > 0)
			{
				pulseCounter += dt;
				updatePulse();
			}
		}
		
		private function updatePulse():void
		{
			var f:Number = pulseCounter * data.pulseW;
			
			scaleX = 1 + Math.sin(f) * data.pulseA;
			scaleY = 1 + Math.cos(f) * data.pulseA;
		}
	}
}

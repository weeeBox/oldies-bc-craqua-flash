package bc.world.particles 
{
	import bc.core.math.Vector2;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcParticle 
	{
		// Следующая частица в списке (пул или активные частицы)
		public var next:BcParticle;
		
		// Спрайт и битмап для отрисовки
		public var sprite:Sprite = new Sprite();
		private var bitmap:Bitmap = new Bitmap();
		
		// Позиция и скорость
		private var x:Number = 0;
		private var y:Number = 0;
		private var vx:Number = 0;
		private var vy:Number = 0;
		
		private var data:BcParticleData;
		
		private var t:Number = 1;
		private var speed:Number = 1;
		
		private var scale:Number = 0;
		private var scaleDelta:Number = 0;
		
		private var alpha:Number = 0;
		private var alphaDelta:Number = 0;
		
		private var angle:Number = 0;
		private var rotation:Number = 0;
		
		private var frame:uint;
		private var frameTime:Number = 0;

		public function BcParticle()
		{
			BcSpriteUtil.setupFast(sprite);
			sprite.visible = false;
			sprite.addChild(bitmap);
		}	
		
		public function launch(data:BcParticleData, position:Vector2, direction:Vector2, layer:DisplayObjectContainer, index:int = -1):void
		{
			var vel:Number = 0;
			
			if(this.data != data)
			{
				this.data = data;
				
				if(data.bitmap)
				{
					data.bitmap.setupBitmap(bitmap);
				}
			}
			
			if(data.animation)
			{
				frame = 0;
				frameTime = data.animation.timeline[0];
				data.animation.frames[0].setupBitmap(bitmap);
			}
			
			if(data.lifeTime.isZero() && data.animation)
			{
				speed = 1 / data.animation.totalTime;
			}
			else
			{
				speed = 1 / data.lifeTime.getValue();
			}
			
			scale = data.scaleBegin.getValue();
			scaleDelta = data.scaleEnd.getValue() - scale;
			
			alpha = data.alphaBegin.getValue();
			alphaDelta = data.alphaEnd.getValue() - alpha;
			
			angle = data.angle.getValue();
			rotation = data.rotation.getValue();
			
			if(direction)
			{
				vel = data.velocity.getValue();
				vx = direction.x * vel;
				vy = direction.y * vel;
			}
			else
			{
				vx = 0;
				vy = 0;
			}
			
			t = 0;
			
			sprite.x = x = position.x;
			sprite.y = y = position.y;
			sprite.scaleX = scale;
			sprite.scaleY = scale;
			sprite.alpha = alpha;
			
			if(data.oriented && vx * vx + vy * vy > 0.001)
			{
				sprite.rotation = angle + 180*(Math.atan2(vy, vx))/Math.PI;
			}
			else
			{
				sprite.rotation = angle;
			}
			
			if(index>=0)
				layer.addChildAt(sprite, index);
			else
				layer.addChild(sprite);
				
			sprite.visible = true;
		}

		public function update(dt:Number):Boolean
		{
			var a:Number;
			 
			t += dt * speed;
			
			if(data.animation)
			{
				frameTime-=dt;
				if(frameTime <= 0)
				{
					++frame;
					if(frame==data.animation.frames.length)
					{
						frame = 0;
						if(!data.animation.loop)
						{
							t = 1;
						}
					}
					frameTime = data.animation.timeline[frame];
					data.animation.frames[frame].setupBitmap(bitmap);
				}	
			}
			
			if(data.friction > 0)
			{
				a = Math.exp( -dt * data.friction );
				vx *= a;
				vy *= a;
			}
			
			if(data.gravity != 0)
			{
				vy += data.gravity * dt;
			}
			
			x += vx * dt;
			y += vy * dt;
			
			if(data.oriented)
			{
				if(vx * vx + vy * vy > 0.001)
				{
					sprite.rotation = angle + 180*(Math.atan2(vy, vx))/Math.PI;
				}
			}
			else
			{
				sprite.rotation += rotation * dt;
			}
			
			if(scaleDelta!=0)
			{
				sprite.scaleX = scale + t*scaleDelta; 
				sprite.scaleY = scale + t*scaleDelta;
			}
			
			if(alphaDelta!=0)
			{
				sprite.alpha = alpha + t*alphaDelta;
			}
			
			sprite.x = x;
			sprite.y = y;
			
			if(t>=1 && sprite.visible)
			{
				sprite.visible = false;
				sprite.parent.removeChild(sprite);
			}
			
			return sprite.visible;
		}	
	}
}

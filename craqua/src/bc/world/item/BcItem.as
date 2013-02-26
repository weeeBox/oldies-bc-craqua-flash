package bc.world.item 
{
	import flash.display.Sprite;

	import bc.world.particles.BcParticleList;
	import bc.core.audio.BcSound;
	import bc.core.math.Vector2;
	import bc.world.common.BcObject;
	import bc.world.common.BcTrailParticles;
	import bc.world.particles.BcParticleData;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcItem extends BcObject 
	{
		// Следующий бонус в списке
		public var next:BcItem;
		
		// Бонус следует удалить из очереди
		public var dead:Boolean = true;
		
		// Спрайт бонуса
		public var sprite:BcItemSprite;
		
		// Настройки бонуса
		public var data:BcItemData;
		
		// Скорость движения
		public var velocity:Vector2 = new Vector2();
		
		public var trail:BcTrailParticles;
		
		// Время
		public var time:Number;
		public var atBottom:Boolean;
		
		private static var CONST_REFLECTION:Number = -0.9;
		
		public function BcItem()
		{
			super();
			
			// Базовые настройки объекта
			mask = MASK_ITEM;
						
			objectSprite = sprite = new BcItemSprite(this);

			//shape = new BcAABBShape(0, 0, 16, 16);
			
			trail = new BcTrailParticles(sprite, BcParticleData.getData("trail_air_8"), 0.01);
		}
		
		public function launch(data:BcItemData, position:Vector2, caster:DisplayObject):void
		{
			if(dead)
			{
				
				if(this.data != data)
				{
					this.data = data;
					
					shape = data.shape.clone();
				}
				
				this.position.copy(position);
				
				var a:Number = -Math.PI*Math.random();
				var v:Number = Math.random() * data.phySpeed;
				velocity.x = v*Math.cos(a);
				velocity.y = v*Math.sin(a);
				
				time = 0;
				atBottom = false;
				
				dead = false;
				
				sprite.x = position.x;
				sprite.y = position.y;
				sprite.join(caster);
				
				shape.update(position);
				world.grid.replace(this);
				
				world.items.push(this);
				
				switch(data.type)
				{
					case BcItemData.HEAL:
						world.items.healingAmount += data.amount;
						break;
					case BcItemData.BOMB:
						world.items.bombsAmount += data.amount;
						break;
				}
			}
		}
		
		public function update(dt:Number):void
		{
			var fr:Number = Math.exp(-data.phyFriction * dt);
			
			var magnitPosition:Vector2 = world.player.position;
			var magnitDistance:Number = magnitPosition.distance(position);
			var magnitForce:Number;
			
			if(magnitDistance < data.magnitDistance)
			{
				magnitForce = (1 - magnitDistance/data.magnitDistance)*data.magnitForce*dt;
				velocity.x += (magnitPosition.x - position.x)*magnitForce;
				velocity.y += (magnitPosition.y - position.y)*magnitForce;
			}
			velocity.y += data.phyGravity*dt;
			
			velocity.x *= fr;
			velocity.y *= fr;
		
			movement.x = velocity.x * dt;
			movement.y = velocity.y * dt;
			
			move(dt);
			
			if(atBottom)
			{
				time += dt * 0.25;
			}

			if(data.spining > 0)
			{
				sprite.rotation += data.spining * velocity.x * dt;
			}
			sprite.update(dt);
			trail.update(dt, velocity);
			
			if(time >= 1)
			{
				exit();
			}
		}
		
		protected override function checkBounds():void
		{
			var positionChanged:Boolean;
				
			if(shape.xmin < 0)
			{
				position.x -= shape.xmin;
				velocity.x = CONST_REFLECTION * velocity.x;
				positionChanged = true;
			}
			else if(shape.xmax > world.width)
			{
				position.x -= shape.xmax - world.width;
				velocity.x = CONST_REFLECTION * velocity.x;
				positionChanged = true;
			}
			
			/*if(shape.ymin < 0)
			{
				position.y -= shape.ymin;
				velocity.y = CONST_REFLECTION * velocity.y;
				positionChanged = true;
			}*/
			if(shape.ymax > world.height)
			{
				position.y -= shape.ymax - world.height;
				velocity.y = CONST_REFLECTION * velocity.y;
				positionChanged = true;
				atBottom = true;
			}
				
			if(positionChanged)
			{
				shape.update(position);
			}
		}
		
		public function pick():void
		{
			if(data.sfxPick)
			{
				data.sfxPick.playObject(position.x, position.y);
			}
			if(data.particle)
			{
				world.particles.launchCircleArea(data.particle, position, 0, data.particleCount, world.mainLayer);
			}
			exit();
		}
		
		public function exit():void
		{
			if(!dead)
			{
				dead = true;
				world.grid.remove(this);
				sprite.exit();
				
				switch(data.type)
				{
					case BcItemData.HEAL:
						world.items.healingAmount -= data.amount;
						break;
					case BcItemData.BOMB:
						world.items.bombsAmount -= data.amount;
						break;
				}
			}
		}
	
	}
}

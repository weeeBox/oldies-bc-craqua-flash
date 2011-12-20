package bc.world.bullet 
{
	import bc.core.math.Vector2;
	import bc.game.BcGameGlobal;
	import bc.world.collision.BcArbiter;
	import bc.world.collision.BcCollision;
	import bc.world.collision.BcContact;
	import bc.world.collision.BcShape;
	import bc.world.common.BcObject;
	import bc.world.common.BcObjectDamage;
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.player.BcPlayer;

	/**
	 * @author Elias Ku
	 */
	public class BcBullet 
	{
		// Следующая пуля в списке
		public var next:BcBullet;
		
		// Флаг на удаление из очереди
		public var dead:Boolean = true;
		
		// Ссылка на мир
		public var world:BcWorld;
		
		// Переменные движения
		public var position:Vector2 = new Vector2();
		public var velocity:Vector2 = new Vector2();
		public var direction:Vector2 = new Vector2();
		public var impulse:Vector2 = new Vector2();
		public var impulseFriction:Number = 10;
		
		// Шейп пули. Если нету, то считается точкой
		public var shape:BcShape;
		
		// Время от начала существования пули
		public var time:Number = 0;
		
		// Спрайт пули
		public var sprite:BcBulletSprite;
		
		// Настройки пули
		public var data:BcBulletData;
			
		// Маска каллижна
		public var mask:uint;
		
		// Тянем модификатор урона
		public var mod:Number = 1;
		
		// нацеливаемся
		public var target:BcObject;
		
		// Хвостовые партиклы
		public var trailCounter:Number = 0;
		
		public var timer:Number = 0;
		
		// Урон
		private static var OBJECT_DAMAGE:BcObjectDamage = new BcObjectDamage();
		
		// 
		private static var VECTOR:Vector2 = new Vector2();
				
		public function BcBullet()
		{
			world = BcGameGlobal.world;
			sprite = new BcBulletSprite(this);
		}
		
		public function launch(data:BcBulletData, position:Vector2, direction:Vector2, mask:uint, mod:Number = 1):void
		{
			if(!dead)
				throw new Error("EkBullet: living bullet in pool.");
			
			if(this.data != data)
			{
				this.data = data;
				
				if(data.shape) shape = data.shape.clone();
				else shape = null;
			}
			
			impulseFriction = data.impulseFriction;
			if(data.impulseLaunch > 0)
			{
				impulse.x = direction.x * data.impulseLaunch;
				impulse.y = direction.y * data.impulseLaunch;
				
				/*if(mask & BcObject.MASK_PLAYER)
					this.direction.y = 1;
				else
					this.direction.y = -1;
					
				this.direction.x = 0;*/
			}
			else
			{
				impulse.x = 
				impulse.y = 0;
			}
			
			this.direction.x = direction.x;
			this.direction.y = direction.y;
			
			velocity.x = this.direction.x * data.velocityLaunch;
			velocity.y = this.direction.y * data.velocityLaunch;
			
			sprite.x = this.position.x = position.x;
			sprite.y = this.position.y = position.y;
			
			this.mask = mask;
			this.mod = mod;
			
			trailCounter = 0;
			
			if(data.timerSpeed > 0)
			{
				timer = 1;
			}
						
			// join
			dead = false;

			world.bullets.push(this);
			
			sprite.onAdd();
			world.mainLayer.addChild(sprite);
			
			time = 0;
		}
		
		public function exit():void
		{
			if(!dead)
			{
				if(target)
				{
					if(target.mask == BcObject.MASK_ENEMY)
						BcEnemy(target).followBullets--;
					target = null;
				}
				dead = true;
				world.mainLayer.removeChild(sprite);
			}
		}

		public function update(dt:Number):void
		{
			var die:Boolean;
			var detonation:Boolean;
			
			time += dt;
			
			if(impulse.lengthSqr() > 0.01)
			{
				impulse.multScalar(Math.exp(-dt*impulseFriction));
			}
			else
			{
				impulse.setZero();
			}
			
			if(data.velocityForce > 0)
			{
				velocity.x += direction.x * data.velocityForce * dt;
				velocity.y += direction.y * data.velocityForce * dt;
			}
			else if(data.velocityForce < 0)
			{
				updateTarget();
				
				if(target)
				{
					direction.x = target.position.x - position.x;
					direction.y = target.position.y - position.y;
					
					direction.normalize();
				}
					
				velocity.x -= direction.x * data.velocityForce * dt;
				velocity.y -= direction.y * data.velocityForce * dt;
			}
			
			if(data.velocityMax > 0 && velocity.length() > data.velocityMax)
			{
				velocity.normalize();
				velocity.x *= data.velocityMax;
				velocity.y *= data.velocityMax;
			}
			
			VECTOR.x = velocity.x + impulse.x;
			VECTOR.y = velocity.y + impulse.y;
			
			position.x += VECTOR.x * dt;
			position.y += VECTOR.y * dt;
			
			
			if(data.trailParticle)
			{
				trailCounter += dt * data.trailSpeed * VECTOR.length();
				
				if(trailCounter >= 1)
				{					
					world.particles.launchTrail(data.trailParticle, position, VECTOR, 0.25, uint(trailCounter), sprite);
					
					trailCounter -= int(trailCounter);
				}
			}
			
			if(shape) shape.update(position);
			
			if ( data.lifeTime > 0 && time >= data.lifeTime )
			{
				die = true;
				detonation = data.hitTimeout;
			}
			
			if( data.wallReflect && checkBounds() )
			{
				detonation = detonation || data.hitWall;
			}
			else if( position.x < -data.size || 
					 position.x > world.width + data.size || 
					 position.y < -data.size || 
					 position.y > world.height + data.size )
			{
				die = true;
			}
			
			if( data.hitEnemy && testCollisions() )
			{
				detonation = true;
			}
			
			if(detonation)
			{
				if(data.hitExplosion)
					data.hitExplosion.explode(position, mask, mod);
					
				if(data.hitParticle)
					world.particles.launch(data.hitParticle, position, null, sprite.parent);
					
				die = true;
			}
			
			if(data.timerSpeed > 0)
			{
				timer -= dt * data.timerSpeed;
				if(timer < 0)
				{
					timer = 1;
					if(data.timerExplosion)
					{
						data.timerExplosion.explode(position, mask, mod);
					}
				}
			}
		
			if(die)
			{
				exit();
			}
			else
			{
				sprite.x = position.x;
				sprite.y = position.y;
				sprite.update(dt);
			}
		}
		
		protected function checkBounds():Boolean
		{
			var positionChanged:Boolean;
			//var lvx:Number = impulse.x + velocity.x;
			//var lvy:Number = impulse.y + velocity.y;
			var bouce:Number = -0.6;
			
			if(shape.xmin < 0)
			{
				position.x -= shape.xmin;
				velocity.x *= bouce;
				impulse.x *= bouce;
				positionChanged = true;
			}
			else if(shape.xmax > world.width)
			{
				position.x -= shape.xmax - world.width;
				velocity.x *= bouce;
				impulse.x *= bouce;
				positionChanged = true;
			}
			
			if(shape.ymin < 0)
			{
				position.y -= shape.ymin;
				velocity.y *= bouce;
				impulse.y *= bouce;
				positionChanged = true;
			}
			else if(shape.ymax > world.height)
			{
				position.y -= shape.ymax - world.height;
				velocity.y *= bouce;
				impulse.y *= bouce;
				positionChanged = true;
			}
				
			if(positionChanged)
			{
				shape.update(position);
				//world.particles.launchFan(BcParticleProperties.getInstance("sparkle"), position, 5, Math.atan2(lvy, lvx) + Math.PI - 0.2, 0.4, world.sprMain);
			}
			
			return positionChanged;
		}
		
		private function testCollisions():Boolean
		{
			var hit:Boolean;
			
			if(mask==BcObject.MASK_ENEMY)
			{
				if(shape)
					world.grid.testShape(shape, mask, world.arbiter);
				else
					world.grid.testPoint(position, mask, world.arbiter);
			}
			else
			{
				testHero();
			}
			
			hit = processCollisions();

			return hit;
		}
		
		private function processCollisions():Boolean
		{
			var collided:Boolean;
			var arbiter:BcArbiter = world.arbiter;
			var contact:BcContact;
			
			if(arbiter.contactCount > 0)
			{
				if(data.hitDamage > 0)
				{
					contact = BcContact(arbiter.contacts[0]);
	
					OBJECT_DAMAGE.amount = mod * data.hitDamage;
					OBJECT_DAMAGE.velocity.copy(velocity);
					OBJECT_DAMAGE.position.copy(position);
					
					if ( mask & BcObject.MASK_ENEMY )
					{
						BcEnemy(contact.object).damage(OBJECT_DAMAGE);
					}
					else
					{
						BcPlayer(contact.object).damage(OBJECT_DAMAGE);
					}
				}
				
				collided = true;
			}
			
			world.arbiter.clear();
			
			return collided;
		}
		
		private function testHero():void
		{
			var arbiter:BcArbiter = world.arbiter;
			var hero:BcPlayer = world.player;
			var i:uint;
			var tail:BcShape;
			
			arbiter.object = hero;
			
			if(shape) BcCollision.testShapes(hero.shape, shape, arbiter);
			else BcCollision.testPointShape(position, hero.shape, arbiter);
			
			for each ( tail in hero.tailShapes )
			{
				if(i == hero.tailCount)
					break;
					
				++i;
				
				if(shape) BcCollision.testShapes(tail, shape, arbiter);
				else BcCollision.testPointShape(position, tail, arbiter);
			}
		}
		
		private function updateTarget():void
		{
			if(mask == BcObject.MASK_ENEMY)
			{
				if( ( !target || BcEnemy(target).dead ) && world.enemies.count > 0)
				{
					var mob:BcEnemy = world.enemies.head;
					var minMob:BcEnemy;
					var minFollows:int = int.MAX_VALUE;
					
					while(mob)
					{
						if(mob.followBullets == 0)
						{
							target = mob;
							mob.followBullets++;
							break;
						}
						else if(mob.followBullets < minFollows)
						{
							minMob = mob;
							minFollows = mob.followBullets;
						}
						mob = mob.next;
					}
					
					if(!mob && minMob)
					{
						target = minMob;
						minMob.followBullets++;
					}
				}
			}
			else
			{
				target = world.player;
			}
		}

	}
}
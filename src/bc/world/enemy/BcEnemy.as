package bc.world.enemy 
{
	import bc.core.motion.easing.BcEaseFunction;
	import bc.core.math.Vector2;
	import bc.core.motion.BcAnimation;
	import bc.core.motion.BcEasing;
	import bc.core.motion.BcMotion;
	import bc.core.util.BcStringUtil;
	import bc.world.common.BcObject;
	import bc.world.common.BcObjectDamage;
	import bc.world.common.BcShadowSprite;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.path.BcEnemyPath;
	import bc.world.enemy.path.BcEnemyPathData;
	import bc.world.enemy.timers.BcIEnemyTimer;
	import bc.world.particles.BcParticleData;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemy extends BcObject 
	{
		public var next:BcEnemy;
		
		// Монстра следует удалить из очереди
		public var dead:Boolean = true;
		
		// Настройки монстра
		public var data:BcEnemyData;
		
		// Спрайт монстра
		public var sprite:BcEnemySprite;
		public var animation:BcAnimation = new BcAnimation();
		public var motionVelocityDirection:BcMotion;
		public var motionMoving:BcMotion;
		
		public var shadow:BcShadowSprite;
		
		// Время выхода, инициализируется уровнем
		public var startTime:Number = 0;
		
		public var health:Number = 100;
		
		// Сколько пуль преследует
		public var followBullets:int;
		
		// Летим горизонтально
		public var horizontal:Boolean;
		
		//public var velocityMax:Number = 0;
		public var velocity:Vector2 = new Vector2();
		//public var direction:Vector2 = new Vector2();
		
		public var time:Number = 0;
		public var timers:Vector.<BcIEnemyTimer>;
		
		public var positionBegin:Vector2 = new Vector2();
		public var positionEnd:Vector2 = new Vector2();
		public var positionProgress:Number = 1;
		public var positionSpeed:Number = 1;
		public var positionEase:BcEaseFunction;
		
		public var trailCounter:Number = 0;
		
		public var path:BcEnemyPath = new BcEnemyPath();
		
		public var touchCounter:Number = 0;
		
		public static var DIRECTION_DEFAULT:Vector2 = new Vector2(0, 1);
		
		private static var VECTOR:Vector2 = new Vector2();
		
		private static const SIDE_WIDTH:Number = 10;
		
		private var hitBonusCounter:uint;
		
		private var bomb:Boolean;
		private var bombPause:Number = 0;
		
		
		public function BcEnemy()
		{
			super();

			mask = MASK_ENEMY;
			
			objectSprite = 
			sprite = new BcEnemySprite(this);
			animation.setTarget(sprite);
			
			shadow = new BcShadowSprite(473);
			
			//
			//direction.assign(0, 1);
		}
		
		public function fallBomb(x:Number, y:Number, targetX:Number, targetY:Number, bombNode:XML = null):void
		{
			if(bombNode)
			{
				var side:int;
				var x:Number = 0;
				
				if(bombNode.hasOwnProperty("@target"))
				{
					BcStringUtil.parseVector2(bombNode.@target, VECTOR);
					targetX = VECTOR.x;
					targetY = VECTOR.y;
				}
				else
				{
					targetX = 100+Math.random()*(world.width-200);
					targetY = 100+Math.random()*(world.height-200);
				}
				
				x = Math.random() * world.width;
				y = -data.size;
				
				positionEase = BcEasing.sineOut;
			}
			position.x = positionBegin.x = x;
			position.y = positionBegin.y = y;
			shape.update(position);
			shadow.update(position.x + 8, position.y, data.size);
			bomb = true;
			bombPause = data.launchPause;
			positionEnd.x = targetX;
			positionEnd.y = targetY;
			
			const dist:Number = positionBegin.distance(positionEnd);
			positionSpeed = data.launchSpeed/dist;
			positionProgress = 0;
			path.enabled = false;
		}

		public function fallDown(x:Number):void
		{
			position.assign(x, 0);
			shape.update(position);
			limitWalls();
			position.y = -data.size;
			shadow.update(position.x + 8, position.y, data.size);
		}
		
		public function fallHorizont(y:Number):void
		{
			horizontal = true;
			position.y = y;
			if(path.flipped)
			{
				position.x = world.width + SIDE_WIDTH + data.size - 1;
			}
			else
			{
				position.x = -SIDE_WIDTH - data.size+1;
			}
				
			shape.update(position);
			shadow.update(position.x + 8, position.y, data.size);
		}
		
		public function setup(data:BcEnemyData, pathData:BcEnemyPathData):void
		{
			this.data = data;
			
			data.cloneTimers(this);
			
			shape = data.shape.clone();
			health = data.health;
			
			sprite.setup(data.modelData);
			
			path.setup(pathData);
			
			if(data.animationData)
			{
				animation.setData(data.animationData);
				motionVelocityDirection = animation.getMotion("velocity_direction");
				motionMoving = animation.getMotion("moving");
			}
		}
		
		private function limitWalls():void
		{
			if(shape.xmin < 0)
				position.x -= shape.xmin;
			else if(shape.xmax > world.width)
				position.x -= shape.xmax - world.width;
		}
		
		protected override function checkBounds():void
		{
			var positionChanged:Boolean;
			
			if(!horizontal && !bomb)
			{
				if(shape.xmin < 0)
				{
					position.x -= shape.xmin;
					positionChanged = true;
				}
				else if(shape.xmax > world.width)
				{
					position.x -= shape.xmax - world.width;
					positionChanged = true;
				}
				
				if(positionChanged)
				{
					if(path)
					{
						path.flipped = !path.flipped;
					}
					
					shape.update(position);
				}
			}
		}

		public function join():void
		{
			if(dead)
			{
				dead = false;
				
				sprite.x = position.x;
				sprite.y = position.y;
				
				world.mainLayer.addChildAt(sprite, world.mainLayer.getChildIndex(world.player.sprite));
				shadow.join();
				
				shape.update(position);
				world.grid.replace(this);
				
				world.enemies.push(this);
				
				if(!bomb)
				{
					sprite.visible = true;
					if(data.initActions)
					{
						doActions(data.initActions);
					}
				}
				
				if(data.launchMarker)
				{
					world.particles.launch(data.launchMarker, positionEnd, null, world.mainLayer);
				}
			}
		}
		
		public function update(dt:Number):void
		{
			time += dt;
			
			var moving:Number = 0;
			var rotation:Number;
			
			if(touchCounter > 0)
			{
				touchCounter -= dt*2;
			}
			
			if(bomb && bombPause > 0)
			{
				bombPause -= dt;
				if(bombPause <= 0)
				{
					sprite.visible = true;
					if(data.initActions)
					{
						doActions(data.initActions);
					}
				}
			}
				
			if(positionProgress < 1 && (!bomb || (bomb && bombPause <=0)))
			{
				positionProgress += dt * positionSpeed;
				if(positionProgress > 1)
				{
					positionProgress = 1;
				}
				
				if(positionEase!=null)
				{
					moving = positionEase.easing(positionProgress);
				}
				else
				{
					moving = positionProgress;
				}
				movement.x = positionBegin.x + (positionEnd.x - positionBegin.x)*moving - position.x;
				movement.y = positionBegin.y + (positionEnd.y - positionBegin.y)*moving - position.y;
				velocity.x = movement.x / dt;
				velocity.y = movement.y / dt;
				
				if(bomb && positionProgress >= 1)
				{
					processDeath();
					return;
				}
			}
			else
			{
				if(path.enabled)
				{
					moving = data.getMoving(time);
					path.calculateVelocity(time, velocity, moving);
					movement.x = velocity.x * dt;
					movement.y = velocity.y * dt;
				}
				else
				{
					movement.x = velocity.x = 
					movement.y = velocity.y = 0;
				}
			}
			
			if(data.trailParticle)
			{
				trailCounter += velocity.length() * data.trailSpeed * dt;
				if(trailCounter >= 1)
				{
					world.particles.launchTrail(data.trailParticle, position, velocity, data.trailSpread, int(trailCounter), sprite);
					trailCounter -= int(trailCounter);
				}
			}
			
			move(dt);
			
			animation.update(dt);
			if(motionMoving)
			{
				motionMoving.manual(moving);
			}
			if(motionVelocityDirection)
			{
				rotation = Math.atan2(velocity.y, velocity.x) * 180/Math.PI;
				
				if(rotation < 0)
				{
					rotation+=360;
				}
				
				motionVelocityDirection.manual(rotation);
			}
			
			sprite.update(dt);
			shadow.update(position.x + 8, position.y, data.size * 2);
			
			if(!bomb)
			{
				if(position.y + data.size >= world.height)
				{
					world.player.onMonsterFall(this);
					
					VECTOR.x = position.x + 8;
					VECTOR.y = 473;
					world.particles.launch(BcParticleData.getData("level_hit_bottom"), 
						VECTOR, null, world.hud.middle, world.hud.middleZeroIndex);
					
					processDeath();
					return;
				}
				
				if(horizontal && path)
				{
					if((path.flipped && position.x + data.size < -SIDE_WIDTH) ||
						(!path.flipped && position.x - data.size > world.width + SIDE_WIDTH))
					{
						exit();
						return;
					}
				}
			}
			
			for each (var timer:BcIEnemyTimer in timers)
			{
				if(dead) break;
				timer.update(dt);
			}
		}
		
		public function exit():void
		{
			if(!dead)
			{
				dead = true;
				world.grid.remove(this);
				sprite.visible = false;
				world.mainLayer.removeChild(sprite);
				shadow.exit();
			}
		}
		
		public function damage(objectDamage:BcObjectDamage):void
		{
			if(dead) return;
			
			push(-objectDamage.velocity.y);
			
			if(objectDamage.amount > 0)
			{
				health -= objectDamage.amount;
				if(health <= 0.05)
				{
					health = 0;
				}
				
				if(data.hitParticle)
				{
					world.particles.launchFan(data.hitParticle, position, 1, 6.28*Math.random(), 0, 
						world.mainLayer, world.mainLayer.getChildIndex(sprite) + 1);
				}
				
				if(data.hitBonus > 0)
				{
					hitBonusCounter += objectDamage.amount;
					while(hitBonusCounter >= data.hitBonus)
					{
						hitBonusCounter -= data.hitBonus;
						doActions(data.hitBonusActions);
					}
				}
				
				if(data.hitCaps)
				{
					processHitCaps(objectDamage.amount);
				}
				
				if(health <= 0)
				{
					world.items.launchEnemyBonus(position, data.gems, data.money, data.bonusProb, sprite);
					processDeath();
				}
				else
				{
					sprite.onDamage();
				}
				
				if(data.boss && world.level.boss == this)
				{
					world.level.bar.setHP(health / data.health);
				}
			}
		}
		
		public function push(impulse:Number):void
		{
			if(impulse > 0 && data.mass > 0 && shape.ymin > 0)
			{
				if(shape.ymin < data.size)
				{
					impulse *= shape.ymin / data.size;
				}
				
				this.impulse.y -= impulse / data.mass;
			}
		}
		
		private function processHitCaps(amount:Number):void
		{			
			var lastCap:Number = (health + amount) / data.health;
			var nowCap:Number = health / data.health;
			
			for each ( var hitCap:BcEnemyHitCap in data.hitCaps )
			{
				if(hitCap.actions && lastCap > hitCap.level && nowCap <= hitCap.level)
				{
					doActions(hitCap.actions);
				}
			}
		}
		
		private function processDeath():void
		{
			if(data.deathActions)
			{
				doActions(data.deathActions);
			}
			
			if(data.deathSound)
			{
				data.deathSound.playObject(position.x, position.y);
			}
			
			exit();
		}
		
		public function doActions(actions:Vector.<BcIEnemyAction>):void
		{	
			for each ( var action:BcIEnemyAction in actions )
			{
				action.action(this);
			}
		}
		
		public function doPositionTween(moveTo:Vector2, time:Number, ease:BcEaseFunction):void
		{
			positionBegin.x = position.x;
			positionBegin.y = position.y;
			positionEnd.x = moveTo.x;
			positionEnd.y = moveTo.y;
			positionProgress = 0;
			positionSpeed = 1/time;
			positionEase = ease;
		}
	}
}

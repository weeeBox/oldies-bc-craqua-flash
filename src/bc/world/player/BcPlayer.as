package bc.world.player 
{
	import bc.core.audio.BcSound;
	import bc.core.device.BcAsset;
	import bc.core.math.Vector2;
	import bc.world.bullet.BcBullet;
	import bc.world.collision.BcArbiter;
	import bc.world.collision.BcCircleShape;
	import bc.world.collision.BcContact;
	import bc.world.collision.BcShape;
	import bc.world.common.BcObject;
	import bc.world.common.BcObjectDamage;
	import bc.world.common.BcShadowSprite;
	import bc.world.core.BcCheckPoint;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.BcEnemyData;
	import bc.world.item.BcItem;
	import bc.world.item.BcItemData;
	import bc.world.particles.BcParticleData;

	/**
	 * @author Elias Ku
	 */
	public class BcPlayer extends BcObject
	{
		public var sprite:BcPlayerSprite;
		private var shadow:BcShadowSprite;
	
		public var moveDirection:Vector2 = new Vector2();
		
		// Степень передвижения.
		public var moveDivide:Number = 0.2;	
		
		// Максимальное передвижение = 800 по диагонали.
		// но мы умножаем на moveDivide, поэтому максимум будет 
		// 800 * moveDivide. Потом делим это на 32 (размеры нашего героя)
		// и получаем примерно 5 хвостовых шейпов максимум
		public var tailShapes:Vector.<BcCircleShape> = new Vector.<BcCircleShape>(10, true);
		public var tailCount:uint;

		private var money:uint;
		//protected function get safe_money():uint {return uint(SafeMemory.instance.getValue("money"));}
		//protected function set safe_money(value:uint):void { SafeMemory.instance.setValue("money", value); }
		public function getMoney():uint {return money;}
		
		// уровень
		public var levelIndex:int;
		public var levelInfo:BcPlayerLevel;
		// опыт
		
		//protected function get safe_exp():uint {return uint(SafeMemory.instance.getValue("exp"));}
		//protected function set safe_exp(value:uint):void { SafeMemory.instance.setValue("exp", value); }
		public var exp:uint;
		public var expPrev:uint;
		public var expNext:uint;
		public var expProgress:Number = 0;
		
		// уровни грейдов
		public var levels:Vector.<BcPlayerLevel> = new Vector.<BcPlayerLevel>();
		public var claws:Vector.<BcPlayerClaw> = new Vector.<BcPlayerClaw>();
		
		// Флаг стрельбы из дул
		public var shotTrigger:Boolean;
		public var shooting:Boolean;
		public var shootingPause:Number = 0;
		
		// максимальное кол-во бомб
		public const BOMB_COUNT:uint = 6;
		
		// Кол-во бомб в обойке
		//protected function get safe_bombs():uint { return uint(SafeMemory.instance.getValue("bombs")); }
		//protected function set safe_bombs(value:uint):void { SafeMemory.instance.setValue("bombs", value); }
		private var bombClip:uint = BOMB_COUNT;
		
		
		
		// регенерация бомбы
		private var bombRegeneration:Number = 0;
		
		// временный вектор, чтобы запускать снаряды или взрывы
		private var launchPosition:Vector2 = new Vector2();
		// временный вектор, чтобы запускать снаряды или взрывы
		private var launchDirection:Vector2 = new Vector2();
		// временный вектор, чтобы запускать снаряды или взрывы
		private var launchImpulse:Vector2 = new Vector2();
		
		// Жизни
		private var health:int = 100;
		//protected function get safe_health():uint { return uint(SafeMemory.instance.getValue("health")); }
		//protected function set safe_health(value:uint):void { SafeMemory.instance.setValue("health", value); }
		private var loser:Boolean;
		
		// регенерация жизней
		private var healthRegeneration:Number = 0;
		
		// Мигание
		public var damagedCounter:Number = 0;
		
		// Мигание
		public var downgradeTimeout:Number = 2;
		public var downgradePause:Number = 0;
		
		public var sfxHit:BcSound;
		public var sfxShield:BcSound;
		public var sfxUpgrade:BcSound;
		public var sfxDowngrade:BcSound;
		public var sfxDeath:BcSound;
		
		public var hitParticle:BcParticleData;
		public var downParticle:BcParticleData;
		public var deathBubble:BcParticleData;
		public var deathWave:BcParticleData;
		public var deathJip:BcParticleData;

		//private static var EXP_DAMAGE_MOD_ARMOURED:Number = 0.;
		private static var EXP_DAMAGE_MOD:Number = 0.33;
		
		/**
		 * Создать капитана.
		 */
		public function BcPlayer(xmlName:String)
		{
			super();
			
			var i:uint;

			shape = new BcCircleShape(0, 0, 16);
			for ( i = 0; i < tailShapes.length; ++i)
				tailShapes[i] = BcCircleShape(shape.clone());
			tailCount = 0;
			
			mask = MASK_PLAYER;
			objectSprite = sprite = new BcPlayerSprite(this);
			
			parse(BcAsset.getXML(xmlName));
			
			
			sprite.initialize();
			
			sfxHit = BcSound.getData("player_hit");
			sfxShield = BcSound.getData("player_shield");
			sfxUpgrade = BcSound.getData("player_upgrade");
			sfxDowngrade = BcSound.getData("player_downgrade");
			sfxDeath = BcSound.getData("player_death");
			
			hitParticle = BcParticleData.getData("player_hit");
			downParticle = BcParticleData.getData("player_down");
			deathBubble = BcParticleData.getData("player_death_bubble");
			deathWave = BcParticleData.getData("player_death_wave");
			deathJip = BcParticleData.getData("player_death_jip");
			
			shadow = new BcShadowSprite();
			
		}

		public function start():void
		{
			var checkPoint:BcCheckPoint = world.checkPoint;
			
			initMedals();
			loser = false;
			world.hud.start();
			
			tailCount = 0;
			position.assign(320, 400);
			setHealth(checkPoint.health);
			setMoney(checkPoint.money);
			initExp(checkPoint.exp);
			setBombClip(checkPoint.bombs);
			
			// join
			sprite.x = position.x;
			sprite.y = position.y;
			sprite.initialize();
			sprite.visible = true;
			world.mainLayer.addChild(sprite);
			
			shape.update(position);
			world.grid.replace(this);
			
			shadow.join();
			
			
		}

		public function exit():void
		{
			world.grid.remove(this);
			shadow.exit();
			sprite.visible = false;
			world.mainLayer.removeChild(sprite);
		}

		public function update(dt:Number):void
		{
			if(loser) return;
			
			// Считаем длину пути
			var moveLength:Number = moveDirection.normalize() * (moveDivide*dt*60);
			var iterations:uint = uint(moveLength/32) + 1;
			if(iterations > 5) iterations = 5;
			var stepTime:Number = dt / iterations;
			var stepLength:Number = moveLength / iterations;
			var bodyShape:BcShape = shape;
			var tail:BcShape;
			var i:int;
			
			tailCount = 0;
			
			updatePreIterations(dt);
			
			while(i < iterations)
			{
				movement.x = moveDirection.x * stepLength;
				movement.y = moveDirection.y * stepLength;
			
				move(stepTime);
				updateWeapons(stepTime);
				checkBonuses();
				checkEnemies();
				
				++i;
				
				if(i < iterations)
				{
					tail = tailShapes[tailCount];
					tail.worldPosition.copy(bodyShape.worldPosition);
					tail.xmax = bodyShape.xmax;
					tail.ymax = bodyShape.ymax;
					tail.xmin = bodyShape.xmin;
					tail.ymin = bodyShape.ymin;
					
					++tailCount;
				}
			}
			
			sprite.onMoving(moveDirection, moveLength);
			sprite.update(dt);
			shadow.update(sprite.x + 8, sprite.y, 32);
		}
		
		public function updatePreIterations(dt:Number):void
		{
			if(shotTrigger && shootingPause < 1)
			{
				shootingPause += dt*6;
				if(shootingPause > 1)
					shootingPause = 1;
			}
			else if(!shotTrigger && shootingPause > 0)
			{
				shootingPause -= dt*6;
				if(shootingPause < 0)
					shootingPause = 0;
			}
			
			shooting = shotTrigger && (shootingPause >= 1);
			
			if( health < 100)
			{
				healthRegeneration -= dt;
				if(healthRegeneration <= 0)
				{
					setHealth(health + 1);
					healthRegeneration = levelInfo.regenHealth;
				}
			}
			
			if(downgradePause > 0) downgradePause -= dt;
		}
		
		private function updateWeapons(dt:Number):void
		{
			// Скорострельность на единицу времени, учитываем настройки и промежуток времени 
			var speed:Number;
			
			// дуло
			
			var claw:BcPlayerClaw;
			var launchDoImpulse:Boolean;
			var launchedBullet:BcBullet;
			var i:int;
			var j:int;
			var angle:Number;
			var angleDelta:Number;
			
			for each (var weapon:BcPlayerWeapon in levelInfo.weapons)
			{
				if(!weapon)
				{
					break;
				}
				
				claw = claws[i];
				speed = weapon.rate * levelInfo.modRate * dt;
				
				// Если стреляем и дуло активно на уровне грейда, 
				// то обрабатываем счетчик огневой очереди
				if( shooting )
				{
					weapon.burst += speed;
				
					// Если сработала очередь - стреляем. Не делаем while, 
					// потому что снаряды которые совершенно одинаковые в один кадр нам не нужны
					if ( weapon.burst >= 1 )
					{
						j = weapon.count;
						if(j > 1)
						{
							angle = weapon.angle - weapon.fan * 0.5;
							angleDelta = weapon.fan / (j - 1);
						}
						else
						{
							angle = weapon.angle;
						}

						if(!weapon.sync)
						{
							weapon.query = ((weapon.query + 1) & 1);
						}
						
						while(j > 0)
						{
							launchPosition.x = position.x + claw.position.x;
							launchPosition.y = position.y + claw.position.y;
							launchDoImpulse = (weapon.impulse!=null);
							if(launchDoImpulse) launchImpulse.copy(weapon.impulse);
							launchDirection.x = Math.cos(angle);
							launchDirection.y = Math.sin(angle);
							
							if(weapon.sync)
							{
								if(weapon.bullet)
								{
									launchedBullet = world.bullets.launch(weapon.bullet, launchPosition, launchDirection, MASK_ENEMY, levelInfo.modDamage);
									if(launchDoImpulse && launchedBullet)
									{
										launchedBullet.impulse.x += launchImpulse.x;
										launchedBullet.impulse.y += launchImpulse.y;
									}
								}
									
								launchPosition.x = position.x - claw.position.x;
								launchDirection.x = -launchDirection.x;
								launchImpulse.x = -launchImpulse.x;
							}
							else
							{
								if(weapon.query)
								{
									launchPosition.x = position.x - claw.position.x;
									launchDirection.x = -launchDirection.x;
									launchImpulse.x = -launchImpulse.x;
								}
							}
	
							if(weapon.bullet)
							{
								launchedBullet = world.bullets.launch(weapon.bullet, launchPosition, launchDirection, MASK_ENEMY, levelInfo.modDamage);
								if(launchDoImpulse && launchedBullet)
								{
									launchedBullet.impulse.x += launchImpulse.x;
									launchedBullet.impulse.y += launchImpulse.y;
								}
							}
							
							--j;
							angle += angleDelta;
						}

						if(weapon.sfx)
							weapon.sfx.playObject(position.x, position.y);

						weapon.burst -= 1;
						
						sprite.onShot(i);
					}
				}
				// Если не стреляем, но очередь не восстановилась - восстанавливаем очередь
				else if(weapon.burst<1)
				{
					weapon.burst += speed;
					if(weapon.burst>1)
					{
						weapon.burst = 1;
					}
				}

				++i;
			}
			
			if( bombClip < BOMB_COUNT && bombRegeneration > 0 )
			{
				bombRegeneration -= dt;
				if(bombRegeneration <= 0)
				{
					//++bombClip;
					//world.hud.bombs.onRegen();
					setBombClip(bombClip + 1);
					bombRegeneration = levelInfo.regenBomb;
				}
			}
		}
		
		public function launchBomb():void
		{
			if(bombClip > 0)
			{
				for each (var bomb:BcPlayerWeapon in levelInfo.bombs)
				{
				
					launchPosition.x = position.x + bomb.position.x;
					launchPosition.y = position.y + bomb.position.y;
					launchDirection.x = Math.cos(bomb.angle);
					launchDirection.y = Math.sin(bomb.angle);
						
					if(bomb.bullet)
						world.bullets.launch(bomb.bullet, position, launchDirection, MASK_ENEMY, levelInfo.modDamage);
		
					if(bomb.explosion)
						bomb.explosion.explode(position, MASK_ENEMY, levelInfo.modDamage);
					
					if(bomb.sfx)
						bomb.sfx.playObject(launchPosition.x, launchPosition.y);
				}
		
				setBombClip(bombClip - 1);
				//world.hud.bombs.onUse();
				bombRegeneration = levelInfo.regenBomb;
				
				medalRockets = true;
			}
		}
		
		private function checkBonuses():void
		{
			var arbiter:BcArbiter = world.arbiter;
			var contact:BcContact;
			var bonus:BcItem;
			var itemData:BcItemData;
			var i:uint;
			
			world.grid.testObject(this, MASK_ITEM, arbiter);
			
			
			for ( i = 0; i < arbiter.contactCount; ++i )
			{
				contact = BcContact(arbiter.contacts[i]);
				bonus = BcItem(contact.object);
				itemData = bonus.data;
				
				switch(itemData.type)
				{
					case BcItemData.MONEY:
						addMoney(itemData.amount);
						medalBonus++;
						break;
					case BcItemData.GEM:
						pickGems(itemData.amount);
						addMoney(itemData.amount);
						medalBonus++;
						break;
					case BcItemData.HEAL:
						heal(itemData.amount);
						break;
					case BcItemData.BOMB:
						setBombClip(bombClip + itemData.amount);
						break;
				}
				
				bonus.pick();
			}
			
			arbiter.clear();
		}
		
		// Урон
		private static var TOUCH_DAMAGE:BcObjectDamage = new BcObjectDamage();
		
		private function checkEnemies():void
		{
			var arbiter:BcArbiter = world.arbiter;
			var contact:BcContact;
			var enemy:BcEnemy;
			var enemyData:BcEnemyData;
			var i:uint;
			
			world.grid.testObject(this, MASK_ENEMY, arbiter);
			
			for ( i = 0; i < arbiter.contactCount; ++i )
			{
				contact = BcContact(arbiter.contacts[i]);
				enemy = BcEnemy(contact.object);
				enemyData = enemy.data;
				
				if(enemy.touchCounter <= 0)
				{
					TOUCH_DAMAGE.amount = enemyData.touch;
					TOUCH_DAMAGE.position.x = contact.point.x;
					TOUCH_DAMAGE.position.y = contact.point.y;
					damage(TOUCH_DAMAGE);
					enemy.push(500);
					enemy.touchCounter = 1;
					TOUCH_DAMAGE.amount = uint(enemy.data.health * 0.25);
					if(TOUCH_DAMAGE.amount < 2) TOUCH_DAMAGE.amount = 2;
					else if(TOUCH_DAMAGE.amount > 10) TOUCH_DAMAGE.amount = 10;
					enemy.damage(TOUCH_DAMAGE);
				}
			}
			
			arbiter.clear();
		}
		
		public function damage(objectDamage:BcObjectDamage):void
		{
			var damageValue:Number = objectDamage.amount;
			
			if(health==0) return;

			var fanCount:uint = 3;
			var fanPhase:Number = Math.random()*6.28;
			
			world.particles.launchFan(downParticle, objectDamage.position, fanCount, fanPhase, 6.28*(1-1/fanCount), 
				world.mainLayer, world.mainLayer.getChildIndex(sprite) + 1);
						
			if(shooting)
			{
				sfxHit.playObject(objectDamage.position.x, objectDamage.position.y);
			}
			else
			{
				damageValue *= 0.5;
				if(damageValue < 1)
				{
					damageValue = 1;
				}
				
				sfxShield.playObject(objectDamage.position.x, objectDamage.position.y);
			}
			
			if(kickGrade(!shooting))
			{
				world.particles.launchFan(hitParticle, objectDamage.position, fanCount, fanPhase + 3.14/fanCount, 6.28*(1-1/fanCount), 
					world.mainLayer, world.mainLayer.getChildIndex(sprite) + 1);
				world.tweenShake(1);
			}
			
			setHealth(health - uint(damageValue));			
			sprite.onDamage();
			
			medalDamage = true;
		}
		
		public function onMonsterFall(monster:BcEnemy):void
		{
			setHealth(health - monster.data.fail);
			world.tweenShake(1);
			
			medalBottom = true;
		}

		private function parse(xml:XML):void
		{
			var claw:BcPlayerClaw;
			var lvl:BcPlayerLevel;
			
			moveDivide = Number(xml.moving[0].@div);
			
			for each (var clawNode:XML in xml.claw)
			{
				claw = new BcPlayerClaw();
				claw.parse(clawNode);
				claws.push(claw);
			}

			for each (var levelNode:XML in xml.level)
			{
				lvl = new BcPlayerLevel();
				lvl.parse(levelNode);
				levels.push(lvl);
			}
		}
		
		private function heal(amount:uint):void
		{
			if(amount > 0)
			{
				setHealth(health + amount);
			}
		}
		
		public function addMoney(amount:uint):void
		{
			if(amount>0)
			{
				setMoney(money + amount);
				world.hud.money.onGood();
			}
		}
		
		private function setMoney(value:int):void
		{
			money = value;
			world.hud.money.updateValue(money);
		}
		
		private function setHealth(value:int):void
		{
			if(value < 0) value = 0;
			else if(value > 100) value = 100;
			
			if(health > 0 && value == 0)
			{
				onDeath();
			}
			
			health = value;
			
			world.hud.health.updateValue(health);
		}
		
		private function setBombClip(value:int):void
		{
			if(value < 0) value = 0;
			else if(value > BOMB_COUNT) value = BOMB_COUNT;
			
			bombClip = value;
			
			world.hud.bombs.setValue(bombClip);
		}
		
		private function initExp(exp:uint):void
		{
			levelIndex = 0;
			
			for each (var lvl:BcPlayerLevel in levels)
			{
				if(lvl.exp > exp)
				{
					levelInfo = lvl;
					break;
				}
				++levelIndex;
			}
			
			if(levelIndex == levels.length)
			{
				--levelIndex;
				levelInfo = levels[levelIndex];
			}
			
			this.exp = exp;
			calcExpBounds();
			calcExpProgress();
			
			// expIndicator: init
			world.hud.exp.setIndicator(expProgress);

			// sprite: onLevelInit
			onLevelChanged();
		}
	
		private function pickGems(amount:uint):void
		{
			var upgrade:Boolean;
			
			if(amount > 0 && levelIndex + 1 < levels.length)
			{
				exp = exp + amount;
				while(levelIndex+1 < levels.length && exp >= expNext)
				{
					++levelIndex;
					levelInfo = levels[levelIndex];
					calcExpBounds();
					upgrade = true;
				}
				
				calcExpProgress();

				if(upgrade)
				{
					sfxUpgrade.play();
							
					onLevelChanged();
					world.hud.exp.setIndicator(0);
					world.hud.exp.onLevelup();
				}
				
				world.hud.exp.setProgress(expProgress);
			}
			
			world.hud.exp.onGemPick();
		}
		
		private function kickGrade(armour:Boolean):Boolean
		{
			var kicked:Boolean = false;
			var expNew:int;
			var expDown:int = (expNext - expPrev)*EXP_DAMAGE_MOD;
			
			if(armour)
			{
				expDown /= 2;
			}
			
			expNew = exp - expDown;
			if(expNew < 0)
			{
				expNew = 0;
			}
			
			if(armour && expNew < expPrev)
			{
				expNew = expPrev;
				world.tweenShake(1);
			}
			else
			{
				world.tweenShake(0.5);				
			}
			
			exp = expNew;
			
			while(levelIndex > 0 && exp < expPrev)
			{
				--levelIndex;
				levelInfo = levels[levelIndex];
				calcExpBounds();
				kicked = true;
			}
			
			calcExpProgress();

			if(kicked)
			{
				sfxDowngrade.play();
				onLevelChanged();
				world.hud.exp.setIndicator(1);
			}
				
			world.hud.exp.setProgress(expProgress);
			
			return kicked;
		}
		
		private function onLevelChanged():void
		{
			sprite.onLevel();
			

			world.hud.exp.setLevel(levelIndex);
			
			// expIndicator: update level digit
		}
		
		private function calcExpBounds():void
	    {
	    	expNext = levels[levelIndex].exp;
	    	
	    	if(levelIndex>0)
	    	{
	    		expPrev = levels[levelIndex - 1].exp;
			}
			else
			{
				expPrev = 0;
			}
		}
		
		private function calcExpProgress():void
	    {
	    	if(levelIndex + 1 < levels.length)
	    	{
	    		expProgress = (exp - expPrev)/(expNext - expPrev);
	    	}
	    	else
	    	{
	    		expProgress = 1;
	    	}
		}
		
		public function fillCheckPoint(checkPoint:BcCheckPoint):void
	    {
	    	checkPoint.health = health;
	    	checkPoint.money = money;
	    	checkPoint.bombs = bombClip;
	    	checkPoint.exp = exp;
		}
		
		public function isDead():Boolean
	    {
	    	return loser; 
		}
		
		public function getHealthNeed():int
	    {
	    	return ( 100 - health ); 
		}
		
		public function getBombsNeed():int
	    {
	    	return ( BOMB_COUNT - bombClip ); 
		}
		
		private function onDeath():void
		{
			sprite.visible = false;
			
			world.tweenShake(1);
			world.tweenFlash(1);
			sfxDeath.playObject(position.x, position.y);
			
			world.particles.launchCircleArea(deathJip, position, 16, 6, world.mainLayer);
			world.particles.launch(deathWave, position, null, world.mainLayer);
			world.particles.launchCircleArea(deathBubble, position, 16, 16, world.mainLayer);
			world.particles.launchCircleArea(hitParticle, position, 16, 9, world.mainLayer);
			
			loser = true;
		}
		
		public var uiRockets:Boolean;
		public var uiDamage:Boolean;
		public var uiBottom:Boolean;
		public var uiBonus:Boolean;
		public var uiComplete:Boolean;
		
		private var medalRockets:Boolean;
		private var medalDamage:Boolean;
		private var medalBottom:Boolean;
		public var medalTotalBonus:uint;
		private var medalBonus:uint;
		
		public const M_ROCKETS:Number = 0.10;
		public const M_DAMAGE:Number = 0.25;
		public const M_BOTTOM:Number = 0.25;
		public const M_BONUS:Number = 0.20;
		public const M_COMPLETE:Number = 0.10;
		
		private function initMedals():void
		{
			medalRockets = 
			medalDamage = 
			medalBottom = false;
			medalTotalBonus = medalBonus = 0;
		}
		
		public function calcMedals():void
		{
			var rank:uint;
			var bonus:int;
			
			uiRockets = !medalRockets;
			uiDamage = !medalDamage;
			uiBottom = !medalBottom;
			uiBonus = (medalBonus/medalTotalBonus) > 0.9;
			uiComplete = !loser;
			
			if(uiRockets)
			{
				rank++;
				bonus += M_ROCKETS * money;
			}
			
			if(uiDamage)
			{
				rank++;
				bonus += M_DAMAGE * money;
			}
			
			if(uiBottom)
			{
				rank++;
				bonus += M_BOTTOM * money;
			}
			
			if(uiBonus)
			{
				rank++;
				bonus += M_BONUS * money;
			}
			
			if(uiComplete)
			{
				rank++;
				bonus += M_COMPLETE * money;
			}
			
			addMoney(bonus);
			
			switch(rank)
			{
				case 0:
					world.uiRank = "EASY";
					break;
				case 1:
					world.uiRank = "NOT BAD";
					break;
				case 2:
					world.uiRank = "GOOD";
					break;
				case 3:
					world.uiRank = "EXCELLENT";
					break;
				case 4:
					world.uiRank = "AWESOME";
					break;
				case 5:
					world.uiRank = "HARDCORE";
					break;
				default:
					world.uiRank = "???";
					break;
			}
			
			initMedals();
		}
		
	}
}
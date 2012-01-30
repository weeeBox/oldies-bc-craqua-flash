package bc.world.enemy 
{
	import bc.core.audio.BcSound;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcBitmapData;
	import bc.core.display.BcModelData;
	import bc.core.motion.BcAnimationData;
	import bc.world.collision.BcShape;
	import bc.world.enemy.actions.BcEnemyBitmapAction;
	import bc.world.enemy.actions.BcEnemyBonusAction;
	import bc.world.enemy.actions.BcEnemyBulletsAction;
	import bc.world.enemy.actions.BcEnemyCreateAction;
	import bc.world.enemy.actions.BcEnemyExplosionAction;
	import bc.world.enemy.actions.BcEnemyMotionAction;
	import bc.world.enemy.actions.BcEnemyParticlesExp;
	import bc.world.enemy.actions.BcEnemyPathAction;
	import bc.world.enemy.actions.BcEnemyPositionAction;
	import bc.world.enemy.actions.BcEnemySoundAction;
	import bc.world.enemy.actions.BcEnemyTimerAction;
	import bc.world.enemy.actions.BcEnemyWorldAction;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.timers.BcEnemyBaseTimer;
	import bc.world.enemy.timers.BcEnemyTimeline;
	import bc.world.enemy.timers.BcEnemyTimer;
	import bc.world.enemy.timers.BcIEnemyTimer;
	import bc.world.enemy.triggers.BcIEnemyTrigger;
	import bc.world.particles.BcParticleData;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyData implements BcIObjectData
	{
		public var shape:BcShape;
		
		// Масса, влияет на уровень отброса от пули или взрыва
		public var mass:Number = 0;
		
		public var health:Number = 1;
		
		// Урон игроку за пропуск монстра за линию обороны
		public var fail:uint = 10;
		
		// урон игроку за прикосновение
		public var touch:uint = 2;
		
		// Модификатор урона на взрывы и пули
		public var mod:Number = 1;
		
		// Сколько денег и опыта впадает из убитого монстра
		public var gems:uint = 1;
		public var money:uint = 1;
		
		// Вероятность выпадения денег и опыта
		public var bonusProb:Number = 0.5;
		
		// Разрем /2 по вертикали
		public var size:Number = 16;
		
		public var movingMin:Number = 0;
		public var movingMax:Number = 1;
		public var movingOffset:Number = 0;
		public var movingTime:Number = 1;
		public var movingType:uint = 0;
		
		public var movingRotation:Number = -0.25;
		public var movingRotationMax:Number = 30;	
		
		// Это обычно значит, что монстр - босс :)
		public var boss:Boolean;
		
		public var triggers:Vector.<BcIEnemyTrigger> = new Vector.<BcIEnemyTrigger>();
		public var timers:Vector.<BcIEnemyTimer> = new Vector.<BcIEnemyTimer>();
		
		public var initActions:Vector.<BcIEnemyAction>;
		
		public var hitParticle:BcParticleData;
		public var hitCaps:Vector.<BcEnemyHitCap>;
		public var hitLight:Number = 1;
		public var hitBonus:uint;
		public var hitBonusActions:Vector.<BcIEnemyAction>;
		
		public var deathActions:Vector.<BcIEnemyAction>;
		public var deathSound:BcSound;
		
		public var bitmapBody:BcBitmapData;
		
		public var modelData:BcModelData;
		public var animationData:BcAnimationData;
		
		public var trailParticle:BcParticleData;
		public var trailSpeed:Number = 1;
		public var trailSpread:Number = 0.25;
		
		public var launchPause:Number = 0;
		public var launchMarker:BcParticleData;
		public var launchSpeed:Number = 0;
		
		public function BcEnemyData()
		{
			
		}
		
		public function parse(xml:XML):void
		{			
			
			var subNode:XML;
				
			var movingNode:XML = xml.moving[0];
			if(movingNode)
			{
				if(movingNode.hasOwnProperty("@min")) movingMin = movingNode.@min;
				if(movingNode.hasOwnProperty("@max")) movingMax = movingNode.@max;
				if(movingNode.hasOwnProperty("@time")) movingTime = movingNode.@time;
				if(movingNode.hasOwnProperty("@offset")) movingOffset = movingNode.@offset;
				if(movingNode.hasOwnProperty("@type"))
				{
					switch(movingNode.@type.toString())
					{
						case "normal":
							movingType = 0;
							break;
						case "saw":
							movingType = 1;
							break;
					}
				}
			}
			
			var propertiesNode:XML = xml.properties[0];
			if(propertiesNode)
			{
				if(propertiesNode.hasOwnProperty("@health")) health = Number(propertiesNode.@health);
				if(propertiesNode.hasOwnProperty("@fail")) fail = Number(propertiesNode.@fail);
				if(propertiesNode.hasOwnProperty("@mod")) mod = Number(propertiesNode.@mod);
				if(propertiesNode.hasOwnProperty("@size")) size = Number(propertiesNode.@size);
				if(propertiesNode.hasOwnProperty("@mass")) mass = Number(propertiesNode.@mass);
				if(propertiesNode.hasOwnProperty("@gems")) gems = propertiesNode.@gems;
				if(propertiesNode.hasOwnProperty("@money")) money = propertiesNode.@money;
			}
			
			var trailNode:XML = xml.trail[0];
			if(trailNode)
			{
				if(trailNode.hasOwnProperty("@particle"))
				{
					trailParticle = BcParticleData.getData(trailNode.@particle);
				}
				if(trailNode.hasOwnProperty("@speed"))
				{
					trailSpeed = trailNode.@speed;
				}
				if(trailNode.hasOwnProperty("@spread"))
				{
					trailSpread = trailNode.@spread;
				}
			}
			
			for each (var timerNode:XML in xml.timer)
			{
				timers.push(createTimer(timerNode));
			}
			
			for each (var triggerNode:XML in xml.trigger)
			{
				triggers.push(createTrigger(triggerNode));
			}
			
			var hitNode:XML = xml.hit[0];
			if(hitNode)
			{
				if(hitNode.hasOwnProperty("@particle"))
				{
					hitParticle = BcParticleData.getData(hitNode.@particle);
				}
				
				if(hitNode.hasOwnProperty("@light"))
				{
					hitLight = hitNode.@light;
				}
				
				
				for each (subNode in hitNode.cap)
				{
					if(!hitCaps) hitCaps = new Vector.<BcEnemyHitCap>();
					hitCaps.push(new BcEnemyHitCap(subNode));
				}
				
				subNode = hitNode.bonus[0];
				if(subNode)
				{
					hitBonus = subNode.@damage;
					hitBonusActions = createActionArray(subNode);
				}
			}
			
			var deathNode:XML = xml.death[0];
			if(deathNode)
			{
				deathActions = createActionArray(deathNode);
				
				if(deathNode.hasOwnProperty("@sfx"))
				{
					deathSound = BcSound.getData(deathNode.@sfx);
				}
			}
			
			var initNode:XML = xml.init[0];
			if(initNode)
			{
				initActions = createActionArray(initNode);
			}
			
			shape = BcShape.createFromXML(xml.shape[0]);
				
			var spriteNode:XML = xml.sprite[0];
			if(spriteNode)
			{
				if(spriteNode.hasOwnProperty("@animation"))
				{
					animationData = BcAnimationData.getData(spriteNode.@animation);
				}
				if(spriteNode.hasOwnProperty("@model"))
				{
					modelData = BcModelData.getData(spriteNode.@model);
				}
			}
			
			
			if(xml.boss[0])
			{
				boss = true;
				bonusProb = 1;
			}
			
			var launchNode:XML = xml.launch[0];
			if(launchNode)
			{
				launchPause = launchNode.@pause;
				launchSpeed = launchNode.@speed;
				launchMarker = BcParticleData.getData(launchNode.@marker);
			}
		}
		
		public function getMoving(time:Number):Number
		{
			var moving:Number = movingMin;
			
			time -= movingOffset;
			if(time > 0)
			{
				switch(movingType)
				{
					case 0:
						if(time > movingTime)
						{
							moving = movingMax;
						}
						else
						{
							moving = movingMin + (movingMax - movingMin)*time/movingTime;
						}
						break;
					case 1:
						time -= uint(time/movingTime)*movingTime;
						moving = movingMax - (movingMax - movingMin)*time/movingTime;
						break;
				}
			}
			
			return moving;
		}
		
		public function cloneTimers(enemy:BcEnemy):void
		{
			var array:Vector.<BcIEnemyTimer>;
			var timer:BcIEnemyTimer;
			var clone:BcIEnemyTimer;
			
			if(timers)
			{
				for each (timer in timers)
				{
					clone = null;
					
					if(timer is BcEnemyTimer)
					{
						clone = new BcEnemyTimer(BcEnemyTimer(timer));
						
					}
					else if (timer is BcEnemyTimeline)
					{
						clone = new BcEnemyTimeline(BcEnemyTimeline(timer));
					}
					
					if(clone)
					{
						if(!array)
						{
							array = new Vector.<BcIEnemyTimer>();
						}
						
						array.push(clone);
						BcEnemyBaseTimer(clone).enemy = enemy;
					}
				}
			}
			
			enemy.timers = array;
		}

		///////////////
		
		public static function createAction(xml:XML):BcIEnemyAction
		{
			var action:BcIEnemyAction;
			var type:String = xml.name().toString();
			
			switch(type)
			{
				case "bullets":
					action = new BcEnemyBulletsAction(xml);
					break;
				case "motion":
					action = new BcEnemyMotionAction(xml);
					break;
				case "circle_particles":
					action = new BcEnemyParticlesExp(xml);
					break;
				case "position":
					action = new BcEnemyPositionAction(xml);
					break;
				case "path":
					action = new BcEnemyPathAction(xml);
					break;
				case "world":
					action = new BcEnemyWorldAction(xml);
					break;
				case "bitmap":
					action = new BcEnemyBitmapAction(xml);
					break;
				case "sfx":
					action = new BcEnemySoundAction(xml);
					break;
				case "explosion":
					action = new BcEnemyExplosionAction(xml);
					break;
				case "timer":
					action = new BcEnemyTimerAction(xml);
					break;
				case "bonus":
					action = new BcEnemyBonusAction(xml);
					break;
				case "create":
					action = new BcEnemyCreateAction(xml);
					break;
					
			}
			
			return action;
			
		}
		
		public static function createActionArray(xml:XML):Vector.<BcIEnemyAction>
		{
			var actions:Vector.<BcIEnemyAction>;
			var list:XMLList = xml.children();			
			
			for each (var node:XML in list)
			{
				if(!actions)
				{
					actions = new Vector.<BcIEnemyAction>();
				}
				
				actions.push(createAction(node));
			}
			
			return actions;
		}
		
		private static function createTrigger(xml:XML):BcIEnemyTrigger
		{
			var trigger:BcIEnemyTrigger;
			var type:String = xml.@type;
			
			return trigger;
		}
		
		private static function createTimer(xml:XML):BcIEnemyTimer
		{
			var timer:BcIEnemyTimer;
			var type:String;
			
			if(xml.hasOwnProperty("@type"))
			{
				type = xml.@type;
			}
			
			if(!type || type=="timer")
			{
				timer = new BcEnemyTimer();
			}
			else if(type=="timeline")
			{
				timer = new BcEnemyTimeline();
			}
			
			timer.parse(xml);
			
			return timer;
		}
		
		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("enemy", BcEnemyData, data);
		}
		
		public static function getData(id:String):BcEnemyData
		{
			return BcEnemyData(data[id]);
		}
	}
}
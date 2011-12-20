package bc.world.bullet 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcBitmapData;
	import bc.world.collision.BcShape;
	import bc.world.particles.BcParticleData;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcBulletData implements BcIObjectData
	{
		/** Настройки СПРАЙТА ПУЛИ **/
			
		public var bodyBitmap:BcBitmapData;
		public var bodyOriented:Boolean;
		public var bodyRotation:Number = 0;
		
		/** Настройки ПАРТИКЛОВ СЛЕДА **/
			
		public var trailParticle:BcParticleData;
		public var trailSpeed:Number = 1;
		
		/** Настройки ДВИЖЕНИЯ ПУЛИ **/
		
		public var impulseLaunch:Number = 0;
		public var impulseFriction:Number = 10;
		
		// модуль начальной скорости пули
		public var velocityLaunch:Number = 0;
		// Разгон пули по направлению. Если (vf < 0), то самонаводится с силой по направлению к цели
		public var velocityForce:Number = 0;
		// Если (vm > 0), то ограничиваем модуль скорости 
		public var velocityMax:Number = 0;
		
		/** Настройки СВОЙСТ ПУЛИ **/
	
		// Размер пули, детектиться, когда вылетает за экран
		public var size:Number = 0;
		
		// Время жизни пули
		public var lifeTime:Number = 0;
		
		// Шейп для пули
		public var shape:BcShape;
		
		// отражаться от границ
		public var boundsDie:Boolean;
		
		/** Настройки СОБЫТИЯ ПОПАДАНИЯ ПУЛИ **/
		
		// взрыв
		public var hitWall:Boolean;
		public var hitEnemy:Boolean = true;
		public var hitTimeout:Boolean = true;
		public var hitDamage:Number = 0;
		public var hitExplosion:BcExplosion;
		public var hitParticle:BcParticleData;
		
		public var wallReflect:Boolean;
		
		public var timerSpeed:Number;
		public var timerExplosion:BcExplosion;
		
		public var pulseA:Number = 0;
		public var pulseW:Number = 0;
				
		public function BcBulletData()
		{
		}
			
		public function parse(xml:XML):void
		{
			var node:XML;
			
			node = xml.impulse[0];
			if(node)
			{
				if(node.hasOwnProperty("@friction")) impulseFriction = Number(node.@friction);
				if(node.hasOwnProperty("@launch")) impulseLaunch = Number(node.@launch);
			}

			node = xml.velocity[0];
			if(node)
			{
				if(node.hasOwnProperty("@launch")) velocityLaunch = Number(node.@launch);
				if(node.hasOwnProperty("@max")) velocityMax = Number(node.@max);
				if(node.hasOwnProperty("@force")) velocityForce = Number(node.@force);
			}
			
			node = xml.properties[0];
			if(node)
			{
				if(node.hasOwnProperty("@time")) lifeTime = Number(node.@time);
				if(node.hasOwnProperty("@size")) size = Number(node.@size);
			}
			
			node = xml.reflect[0];
			if(node)
			{
				wallReflect = true;
			}
			
			node = xml.hit[0];
			if(node)
			{
				if(node.hasOwnProperty("@damage")) hitDamage = Number(node.@damage);
				if(node.hasOwnProperty("@explosion")) hitExplosion = BcExplosion.getData(node.@explosion);
				if(node.hasOwnProperty("@wall")) hitWall = (node.@wall.toString()=="true");
				if(node.hasOwnProperty("@enemy")) hitEnemy = (node.@enemy.toString()=="true");
				if(node.hasOwnProperty("@timeout")) hitTimeout = (node.@timeout.toString()=="true");
				if(node.hasOwnProperty("@particle")) hitParticle = BcParticleData.getData(node.@particle.toString());
			}
			
			node = xml.timer[0];
			if(node)
			{
				if(node.hasOwnProperty("@speed")) timerSpeed = node.@speed;
				if(node.hasOwnProperty("@explosion")) timerExplosion = BcExplosion.getData(node.@explosion);
			}
			
			node = xml.shape[0];
			if(node)
			{
				shape = BcShape.createFromXML(node);
			}
				
			
			node = xml.trail[0];
			if(node)
			{
				if(node.hasOwnProperty("@particle")) trailParticle = BcParticleData.getData(node.@particle.toString());
				if(node.hasOwnProperty("@speed")) trailSpeed = node.@speed;
			}
			
			node = xml.body[0];
			if(node)
			{
				bodyBitmap = BcBitmapData.getData(node.@bitmap.toString());
				if(node.hasOwnProperty("@oriented")) bodyOriented = (node.@oriented.toString()=="true");
				if(node.hasOwnProperty("@rotation")) bodyRotation = node.@rotation;
				if(node.hasOwnProperty("@pulse_a")) pulseA = node.@pulse_a;
				if(node.hasOwnProperty("@pulse_w")) pulseW = node.@pulse_w;
			}
			
			
			
		}		
		
		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("bullet", BcBulletData, data);
		}
		
		public static function getData(id:String):BcBulletData
		{
			return BcBulletData(data[id]);
		}
	}
}

package bc.world.player 
{
	import bc.core.audio.BcSound;
	import bc.core.math.Vector2;
	import bc.core.util.BcStringUtil;
	import bc.world.bullet.BcBulletData;
	import bc.world.bullet.BcExplosion;

	/**
	 * @author Elias Ku
	 */
	internal class BcPlayerWeapon 
	{
		// Счётчик, который отсчитывает паузу между выстрелами
		public var burst:Number = 0;
		
		// Скорость стрельбы главного  автомата
		public var rate:Number = 1;	
		
		// синхронизация
		public var sync:Boolean;
		public var query:int;
		
		// Сдвиг
		public var position:Vector2 = new Vector2();
		// Направление стрельбы
		public var angle:Number = - Math.PI * 0.5;
		public var impulse:Vector2;
		
		
		
		// Настройка пули
		public var bullet:BcBulletData;
		
		// Взрыв
		public var explosion:BcExplosion;
		
		// Звук
		public var sfx:BcSound;
		
		public var count:uint = 1;
		public var fan:Number = 0;
		
		public function BcPlayerWeapon()
		{
		}

		public function parse(xml:XML):void
		{
			const toRad:Number = Math.PI/180;
			
			if(xml.hasOwnProperty("@rate"))
			{
				rate = xml.@rate;
			}
			
			if(xml.hasOwnProperty("@sync"))
			{
				sync = BcStringUtil.parseBoolean(xml.@sync);
			}
			
			if(xml.hasOwnProperty("@bullet"))
			{
				bullet = BcBulletData.getData(xml.@bullet);
			}
			
			if(xml.hasOwnProperty("@explosion"))
			{
				explosion = BcExplosion.getData(xml.@explosion);
			}
			
			if(xml.hasOwnProperty("@sfx"))
			{
				sfx = BcSound.getData(xml.@sfx);
			}

			if(xml.hasOwnProperty("@position"))
			{
				BcStringUtil.parseVector2(xml.@position, position);
			}
			
			if(xml.hasOwnProperty("@angle"))
			{
				angle = (-90 - Number(xml.@angle))*toRad;
			}
			
			if(xml.hasOwnProperty("@count"))
			{
				count = xml.@count;
			}
			
			if(xml.hasOwnProperty("@fan"))
			{
				fan = Number(xml.@fan)*toRad;
			}
			
			if(xml.hasOwnProperty("@impulse"))
			{
				impulse = BcStringUtil.parseVector2(xml.@impulse, impulse);
			}
		}
	}
}

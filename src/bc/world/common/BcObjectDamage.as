package bc.world.common 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcObjectDamage 
	{
		// Вектор направленности удара/взрыва
		public var velocity:Vector2 = new Vector2();
		 
		// Позиция точки удара
		public var position:Vector2 = new Vector2();
				
		// Настройки повреждения
		// public var properties:BcDamageProperties;
		
		// Урон
		public var amount:Number = 0;
		
		public function BcObjectDamage()
		{
			
		}
	}
}

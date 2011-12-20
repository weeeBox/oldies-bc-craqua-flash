package bc.world.core 
{
	import bc.world.player.BcPlayer;

	/**
	 * @author Elias Ku
	 */
	public class BcCheckPoint 
	{
		public var wave:uint;
		public var health:uint;
		public var exp:uint;
		public var money:uint;
		public var bombs:uint;
		
		public function BcCheckPoint()
		{
			reset();
		}
		
		public function copyObject(value:Object):void
		{
			wave = value.wave;
			health = value.health;
			exp = value.exp;
			money = value.money;
			bombs = value.bombs;
		}
		
		public function copy(value:BcCheckPoint):void
		{
			wave = value.wave;
			health = value.health;
			exp = value.exp;
			money = value.money;
			bombs = value.bombs;
		}
		
		public function reset():void
		{
			wave = 0;
			health = 100;
			exp = 0;
			money = 0;
			bombs = BcPlayer.BOMB_COUNT;
		}
	}
}

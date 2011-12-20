package bc.world.enemy.actions 
{
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyWorldAction implements BcIEnemyAction 
	{
		private var flash:Number = 0;
		private var shake:Number = 0;
		
		public function BcEnemyWorldAction(xml:XML)
		{
			if(xml.hasOwnProperty("@flash"))
			{
				flash = xml.@flash;
			}
			
			if(xml.hasOwnProperty("@shake"))
			{
				shake = xml.@shake;
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			var world:BcWorld = enemy.world;
			
			if(flash > 0)
			{
				world.tweenFlash(flash);
			}
			
			if(shake > 0)
			{
				world.tweenShake(shake);
			}
		}

	}
}

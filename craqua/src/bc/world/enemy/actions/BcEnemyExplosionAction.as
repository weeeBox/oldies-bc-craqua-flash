package bc.world.enemy.actions 
{
	import bc.world.bullet.BcExplosion;
	import bc.world.common.BcObject;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyExplosionAction implements BcIEnemyAction 
	{
		
		
		private var explosion:BcExplosion;

		
		public function BcEnemyExplosionAction(xml:XML)
		{
			if(xml.hasOwnProperty("@data"))
			{
				explosion = BcExplosion.getData(xml.@data);
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			if(explosion)
			{
				explosion.explode(enemy.position, BcObject.MASK_PLAYER, enemy.data.mod);
			}
		}
	}
}

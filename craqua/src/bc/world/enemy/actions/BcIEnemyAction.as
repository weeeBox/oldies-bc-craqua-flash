package bc.world.enemy.actions 
{
	import bc.world.enemy.BcEnemy;

	/**
	 * @author Elias Ku
	 */
	public interface BcIEnemyAction 
	{
		function action(enemy:BcEnemy):void;
	}
}

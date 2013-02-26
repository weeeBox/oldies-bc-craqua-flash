package bc.world.enemy.triggers 
{
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.triggers.BcIEnemyTrigger;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyTrigger implements BcIEnemyTrigger 
	{
		public function update(enemy:BcEnemy, time:Number, dt:Number):void
		{
		}
		
		public function onHit(enemy:BcEnemy, health:Number, damage:Number):void
		{
		}
	}
}

package bc.world.enemy.triggers 
{
	import bc.world.enemy.BcEnemy;

	/**
	 * @author Elias Ku
	 */
	public interface BcIEnemyTrigger 
	{
		// [time; time + dt]
		function update(enemy:BcEnemy, time:Number, dt:Number):void;
		// [health; health - damage]
		function onHit(enemy:BcEnemy, health:Number, damage:Number):void;
	}
}

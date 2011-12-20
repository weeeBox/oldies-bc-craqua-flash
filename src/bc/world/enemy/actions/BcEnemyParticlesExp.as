package bc.world.enemy.actions 
{
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.particles.BcParticleData;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyParticlesExp implements BcIEnemyAction
	{
		public var particle:BcParticleData;
		public var radius:Number = 0;
		public var count:uint = 1;
		
		
		public function BcEnemyParticlesExp(xml:XML)
		{
			if(xml.hasOwnProperty("@particle"))
			{
				particle = BcParticleData.getData(xml.@particle);
			}
			
			if(xml.hasOwnProperty("@count"))
			{
				count = xml.@count;
			}
			
			if(xml.hasOwnProperty("@radius"))
			{
				radius = xml.@radius;
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			var world:BcWorld = enemy.world;
			if(particle)
			{
				world.particles.launchCircleArea(particle, enemy.position, radius, count, world.mainLayer);
			}
		}
	}
}

package bc.world.enemy.actions 
{
	import bc.core.math.Vector2;
	import bc.world.bullet.BcBulletData;
	import bc.world.bullet.BcBulletLauncher;
	import bc.world.common.BcObject;
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.BcEnemyData;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.path.BcEnemyPathData;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyCreateAction implements BcIEnemyAction 
	{
		private var data:BcEnemyData;
		private var path:BcEnemyPathData;
		private var x:Number = 0;
		
		public function BcEnemyCreateAction(xml:XML)
		{
			if(xml.hasOwnProperty("@data")) data = BcEnemyData.getData(xml.@data);
			if(xml.hasOwnProperty("@path")) path = BcEnemyPathData.getData(xml.@path);
			if(xml.hasOwnProperty("@x")) x = xml.@x;
		}
		
		public function action(enemy:BcEnemy):void
		{
			var enemy:BcEnemy = new BcEnemy();
			enemy.setup(data, path);
			enemy.fallDown(x);
			enemy.join();
		}

	}
}

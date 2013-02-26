package bc.world.enemy.actions 
{
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.path.BcEnemyPathData;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyPathAction implements BcIEnemyAction 
	{
		public var pathData:BcEnemyPathData;
		
		
		public function BcEnemyPathAction(xml:XML)
		{
			if(xml.hasOwnProperty("@data"))
			{
				pathData = BcEnemyPathData.getData(xml.@data);
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			enemy.path.setup(pathData);
		}
	}
}

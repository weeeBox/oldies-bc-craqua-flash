package bc.world.enemy 
{
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyHitCap 
	{
		public var level:Number = 0;
		public var actions:Vector.<BcIEnemyAction>;
		
		public function BcEnemyHitCap(xml:XML)
		{
			level = xml.@level;
			actions = BcEnemyData.createActionArray(xml);
		}
		
	}
}

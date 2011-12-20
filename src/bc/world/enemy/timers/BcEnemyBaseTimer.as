package bc.world.enemy.timers 
{
	import bc.core.util.BcStringUtil;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyBaseTimer 
	{
		public var enemy:BcEnemy;
		public var enabled:Boolean = true;
		
		protected function doActions(array:Vector.<BcIEnemyAction>):void
		{
			if(array)
			{
				for each( var action:BcIEnemyAction in array)
				{
					action.action(enemy);
				}
			}
		}
		
		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@enabled"))
			{
				enabled = BcStringUtil.parseBoolean(xml.@enabled);
			}
		}
	}
}

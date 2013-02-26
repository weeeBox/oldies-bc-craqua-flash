package bc.world.enemy.actions 
{
	import bc.core.util.BcStringUtil;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.timers.BcEnemyBaseTimer;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyTimerAction implements BcIEnemyAction 
	{
		public var index:uint;
		public var enable:Boolean = true;
		public var toogle:Boolean;
		
		public function BcEnemyTimerAction(xml:XML)
		{
			if(xml.hasOwnProperty("@index"))
			{
				index = xml.@index;
			}
			
			if(xml.hasOwnProperty("@enable"))
			{
				if(xml.@enable.toString()=="toogle")
				{
					toogle = true;
				}
				else
				{
					enable = BcStringUtil.parseBoolean(xml.@enable);
				}
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			var baseTimer:BcEnemyBaseTimer = BcEnemyBaseTimer(enemy.timers[index]);
			
			if(toogle)
			{
				baseTimer.enabled = !baseTimer.enabled;
			}
			else
			{
				baseTimer.enabled = enable;
			}
		}
	}
}

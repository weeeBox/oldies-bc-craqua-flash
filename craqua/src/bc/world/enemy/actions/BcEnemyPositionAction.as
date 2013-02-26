package bc.world.enemy.actions 
{
	import bc.core.motion.easing.BcEaseFunction;
	import bc.core.math.Vector2;
	import bc.core.motion.BcEasing;
	import bc.core.util.BcStringUtil;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyPositionAction implements BcIEnemyAction 
	{
		private var position:Vector2 = new Vector2();
		private var time:Number = 1;
		private var ease:BcEaseFunction = BcEasing.linear;
		
		public function BcEnemyPositionAction(xml:XML)
		{
			BcStringUtil.parseVector2(xml.@to, position);
			
			if(xml.hasOwnProperty("@time"))
			{
				time = xml.@time;
			}
			
			if(xml.hasOwnProperty("@ease"))
			{
				ease = BcEasing.getFunction(xml.@ease);
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			enemy.doPositionTween(position, time, ease);
		}
	}
}

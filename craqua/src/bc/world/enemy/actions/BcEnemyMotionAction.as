package bc.world.enemy.actions 
{
	import bc.world.enemy.BcEnemy;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyMotionAction implements BcIEnemyAction
	{
		public var playMotion:String;
		public var stopMotion:String;
		
		
		public function BcEnemyMotionAction(xml:XML)
		{
			if(xml.hasOwnProperty("@play"))
			{
				playMotion = xml.@play.toString();
			}
			
			if(xml.hasOwnProperty("@stop"))
			{
				stopMotion = xml.@stop.toString();
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			if(playMotion)
			{
				enemy.animation.playMotion(playMotion);
			}
			
			if(stopMotion)
			{
				enemy.animation.stopMotion(stopMotion);
			}
		}

	}
}

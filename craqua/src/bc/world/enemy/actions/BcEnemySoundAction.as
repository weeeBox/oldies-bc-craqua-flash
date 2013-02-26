package bc.world.enemy.actions 
{
	import bc.core.audio.BcSound;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemySoundAction implements BcIEnemyAction 
	{
		public var soundData:BcSound;
		
		
		public function BcEnemySoundAction(xml:XML)
		{
			soundData = BcSound.getData(xml.@data.toString());
		}
		
		public function action(enemy:BcEnemy):void
		{
			if(soundData)
			{
				soundData.playObject(enemy.position.x, enemy.position.y);
			}
		}
	}
}

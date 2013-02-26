package bc.world.enemy.timers 
{

	/**
	 * @author Elias Ku
	 */
	public interface BcIEnemyTimer 
	{
		
		function parse(xml:XML):void;
			
		function update(dt:Number):void;
	}
}

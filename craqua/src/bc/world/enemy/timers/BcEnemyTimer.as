package bc.world.enemy.timers 
{
	import bc.world.enemy.BcEnemyData;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.timers.BcEnemyBaseTimer;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyTimer extends BcEnemyBaseTimer implements BcIEnemyTimer
	{
		private var pause:Number = 0;
		private var period:Number = 1;
		private var actions:Vector.<BcIEnemyAction>;
		private var source:BcEnemyTimer;
		
		public function BcEnemyTimer(data:BcEnemyTimer = null)
		{
			if(data)
			{
				pause = data.pause;
				period = data.period;
				source = data;
				enabled = data.enabled;
			}
		}
		
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			
			if(xml.hasOwnProperty("@pause"))
			{
				pause = xml.@pause;
			}
			
			if(xml.hasOwnProperty("@period"))
			{
				period = xml.@period;
			}
			
			actions = BcEnemyData.createActionArray(xml);
		}

		public function update(dt:Number):void
		{
			if(enabled)
			{
				if(pause > 0)
				{
					pause -= dt;
					if(pause <= 0)
					{
						doActions(source.actions);
						period = source.period;
					}
				}
				else
				{
					period -= dt;
					if(period <= 0)
					{
						doActions(source.actions);
						period = source.period;
					}
				}
			}
		}
		
	}
}

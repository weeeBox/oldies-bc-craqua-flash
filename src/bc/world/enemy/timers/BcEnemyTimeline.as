package bc.world.enemy.timers 
{
	import bc.world.enemy.BcEnemyData;
	import bc.world.enemy.timers.BcEnemyBaseTimer;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyTimeline extends BcEnemyBaseTimer implements BcIEnemyTimer
	{
		private var source:BcEnemyTimeline;
		
		private var pause:Number = 0;
		private var index:int;
		private var events:Vector.<BcEnemyTimelineEvent> = new Vector.<BcEnemyTimelineEvent>();
		private var startPause:Number = 0;
		
		
		public function BcEnemyTimeline(data:BcEnemyTimeline = null)
		{
			if(data)
			{
				source = data;
				index = 0;
				pause = data.startPause;
				enabled = data.enabled;
			}
		}
		
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			
			var node:XML;
			var event:BcEnemyTimelineEvent;
			
			for each (node in xml.event)
			{
				event = new BcEnemyTimelineEvent();
				event.actions = BcEnemyData.createActionArray(node);
				if(node.hasOwnProperty("@pause"))
				{
					event.pause = node.@pause;
				}
				events.push(event);
			}
			
			if(xml.hasOwnProperty("@start"))
			{
				startPause = xml.@start;
			}
		}

		public function update(dt:Number):void
		{
			if(enabled)
			{
				pause -= dt;
				if(pause <= 0)
				{
					doActions(source.events[index].actions);
					pause = source.events[index].pause;
					++index;
					if(index >= source.events.length)
					{
						index = 0;
					}
				}
			}
		}
	}
}

import bc.world.enemy.actions.BcIEnemyAction;

internal class BcEnemyTimelineEvent
{
	public var pause:Number = 0;
	public var actions:Vector.<BcIEnemyAction>;
}
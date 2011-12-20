package bc.core.motion.tweens 
{
	import bc.core.motion.tweens.BcITween;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcAngleTween implements BcITween 
	{
		public var start:Number = 0;
		public var change:Number = 0;
		
		public function BcAngleTween(start:Number = 0, change:Number = 0)
		{
			this.start = start;
			this.change = change;
		}
		
		public function parse(xml:XML):void
		{
			start = xml.@start;
			change = xml.@change;
		}

		public function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void
		{
			if(displayObject)
			{
				var value:Number = start + change * progress;
				
				if(weight >= 1)
				{
					displayObject.rotation = value;
				}
				else
				{
					displayObject.rotation = lerpAngles(displayObject.rotation, normalizeAngle(value), weight);
				}
			}
		}
		
		private function normalizeAngle(value:Number):Number
		{
			while(value > 180)
			{
				value -= 360;
			}
			
			while(value < -180)
			{
				value += 360;
			}
			
			return value;
		}
		
		private function lerpAngles(begin:Number, end:Number, t:Number):Number
		{
			return begin + normalizeAngle(end - begin)*t;
		}
	}
}

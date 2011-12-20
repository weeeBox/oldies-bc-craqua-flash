package bc.core.motion.tweens 
{
	import bc.core.util.BcStringUtil;
	import bc.core.math.Vector2;
	import bc.core.motion.tweens.BcITween;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcScaleTween implements BcITween 
	{
		public var start:Vector2 = new Vector2();
		public var change:Vector2 = new Vector2();
		
		public function BcScaleTween(startX:Number = 1, startY:Number = 1, changeX:Number = 0, changeY:Number = 0)
		{
			start.x = startX;
			start.y = startY;
			change.x = changeX;
			change.y = changeY;
		}
		
		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@start"))
			{
				BcStringUtil.parseVector2(xml.@start, start);
			}
			
			if(xml.hasOwnProperty("@change"))
			{
				BcStringUtil.parseVector2(xml.@change, change);
			}
		}

		public function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void
		{
			if(displayObject)
			{
				const valueX:Number = start.x + change.x * progress;
				const valueY:Number = start.y + change.y * progress;
				
				if(weight >= 1)
				{
					displayObject.scaleX = valueX;
					displayObject.scaleY = valueY;
				}
				else
				{
					const invWeight:Number = 1 - weight;

					displayObject.scaleX = displayObject.scaleX * invWeight + valueX * weight;
					displayObject.scaleY = displayObject.scaleY * invWeight + valueY * weight;
				}
			}
		}
	}
}

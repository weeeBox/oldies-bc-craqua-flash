package bc.core.motion.tweens 
{
	import bc.core.motion.tweens.BcITween;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcAlphaTween implements BcITween 
	{
		public var start:Number = 0;
		public var change:Number = 1;
		
		public function BcAlphaTween()
		{
		}
		
		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@start"))
			{
				start = xml.@start;
			}
			
			if(xml.hasOwnProperty("@change"))
			{
				change = xml.@change;
			}
		}

		public function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void
		{
			if(displayObject)
			{
				const value:Number = start + change * progress;
				
				if(weight >= 1)
				{
					displayObject.alpha = value;
				}
				else
				{
					displayObject.alpha = displayObject.alpha * (1 - weight) + value * weight;
				}
				
				if(displayObject.alpha > 0)
				{
					if(!displayObject.visible)	
					{
						displayObject.visible = true;
					}
				}
				else
				{
					if(displayObject.visible)	
					{
						displayObject.visible = false;
					}
				}
			}
		}
	}
}

package bc.core.motion.tweens 
{
	import bc.core.util.BcColorTransformUtil;
	import bc.core.motion.tweens.BcITween;
	import bc.core.util.BcStringUtil;

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcColorTween implements BcITween 
	{
		public var start:ColorTransform = new ColorTransform();
		public var end:ColorTransform = new ColorTransform();
		
		private static var COLOR:ColorTransform = new ColorTransform();
		
		public function BcColorTween()
		{

		}
		
		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@start"))
			{
				BcStringUtil.parseColorTransform(xml.@start, start);
			}
			
			if(xml.hasOwnProperty("@end"))
			{
				BcStringUtil.parseColorTransform(xml.@end, end);
			}
		}

		public function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void
		{
			if(displayObject)
			{
				BcColorTransformUtil.lerpColor(COLOR, start, end, progress);
				
				if(weight >= 1)
				{
					displayObject.transform.colorTransform = COLOR;
				}
				else
				{
					BcColorTransformUtil.lerpColor(COLOR, displayObject.transform.colorTransform, COLOR, weight);
					displayObject.transform.colorTransform = COLOR;
				}
			}
		}
	}
}

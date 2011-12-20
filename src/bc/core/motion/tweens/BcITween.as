package bc.core.motion.tweens 
{
	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public interface BcITween 
	{
		function parse(xml:XML):void;
		function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void;
	}
}

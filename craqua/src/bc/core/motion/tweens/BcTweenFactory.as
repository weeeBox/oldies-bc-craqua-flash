package bc.core.motion.tweens 
{

	/**
	 * @author Elias Ku
	 */
	public class BcTweenFactory 
	{
		public static function createFromXML(xml:XML):BcITween
		{
			var tween:BcITween = createTween(xml.@tween);
			tween.parse(xml);
			return tween;
		}
		
		private static function createTween(className : String) : BcITween 
		{
			if (className == "property")
				return new BcPropertyTween();
			else if (className == "angle")
				return new BcAngleTween();
			else if (className == "scale")
				return new BcScaleTween();
			else if (className == "color")
				return new BcColorTween();
			else if (className == "alpha")
				return new BcAlphaTween();
			return null;
		}		
	}
}

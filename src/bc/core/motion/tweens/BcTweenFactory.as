package bc.core.motion.tweens 
{

	/**
	 * @author Elias Ku
	 */
	public class BcTweenFactory 
	{
		private static var factory:Object = new Object();
		
		public static function initialize():void
		{
			register("property", BcPropertyTween);
			register("angle", BcAngleTween);
			register("scale", BcScaleTween);
			register("color", BcColorTween);
			register("alpha", BcAlphaTween);
		}
		
		public static function register(tweenName:String, tweenClass:Class):void
		{
			factory[tweenName] = tweenClass;
		}
		
		public static function createFromXML(xml:XML):BcITween
		{
			var tween:BcITween = new (factory[xml.@tween.toString()])();
			tween.parse(xml);
			return tween;
		}
		
	}
}

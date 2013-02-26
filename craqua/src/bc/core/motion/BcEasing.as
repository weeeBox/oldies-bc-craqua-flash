package bc.core.motion 
{
	import flash.utils.Dictionary;
	import bc.core.motion.easing.BcEaseFunction;
	import bc.core.motion.easing.BcEaseSineInOut;
	import bc.core.motion.easing.BcEaseSineOut;
	import bc.core.motion.easing.BcEaseSineIn;
	import bc.core.motion.easing.BcEaseStepOut;
	import bc.core.motion.easing.BcEaseStepIn;
	import bc.core.motion.easing.BcEaseLiner;

	/**
	 * @author Elias Ku
	 */
	public class BcEasing
	{
		private static var funcs:Dictionary = new Dictionary();
		public static var linear:BcEaseFunction; 
		public static var stepIn:BcEaseFunction; 
		public static var stepOut:BcEaseFunction; 
		public static var sineIn:BcEaseFunction; 
		public static var sineOut:BcEaseFunction; 
		public static var sineInOut:BcEaseFunction; 
		
		public static function initialize():void
		{
			linear = new BcEaseLiner();
			stepIn = new BcEaseStepIn();
			stepOut = new BcEaseStepOut();
			sineIn = new BcEaseSineIn();
			sineOut = new BcEaseSineOut();
			sineInOut = new BcEaseSineInOut();

			funcs["linear"] = linear;
			funcs["step.in"] = stepIn;
			funcs["step.out"] = stepOut;
			funcs["sine.in"] = sineIn;
			funcs["sine.out"] = sineOut;
			funcs["sine.in.out"] = sineInOut;
		}
		
		public static function getFunction(typeName:String):BcEaseFunction
		{
			return funcs[typeName];
		}
	}
}

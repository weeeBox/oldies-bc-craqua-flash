package bc.core.motion 
{

	/**
	 * @author Elias Ku
	 */
	public class BcEasing
	{
		private static var funcs:Object = new Object();
		
		public static function initialize():void
		{
			funcs["linear"] = linear;
			funcs["step.in"] = stepIn;
			funcs["step.out"] = stepOut;
			funcs["sine.in"] = sineIn;
			funcs["sine.out"] = sineOut;
			funcs["sine.in.out"] = sineInOut;
		}
		
		public static function getFunction(typeName:String):Function
		{
			return funcs[typeName];
		}
		
		//none
		public static function linear(t:Number):Number
		{
			return t;
		}
		
		public static function stepIn(t:Number):Number
		{
			if(t<1) return 0;
			return 1;
		}
		
		public static function stepOut(t:Number):Number
		{
			if(t<1) return 1;
			return 0;
		}
		
		//sine
		
		public static function sineIn(t:Number):Number
		{
			return -Math.cos(t * (Math.PI*0.5)) + 1;
		}
		
		public static function sineOut(t:Number):Number
		{
			return Math.sin(t * (Math.PI*0.5));
		}
		
		public static function sineInOut(t:Number):Number
		{
			return (-0.5)*(Math.cos(Math.PI*t) - 1);
		}
	}
}

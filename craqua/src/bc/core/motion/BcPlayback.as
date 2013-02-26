package bc.core.motion 
{

	/**
	 * @author Elias Ku
	 */
	public class BcPlayback 
	{
		public static const NORMAL:uint = 0;
		public static const REVERSE:uint = 1;
		public static const PINGPONG:uint = 2;
		
		internal static function parseString(string:String):uint
		{
			var value:uint = NORMAL;
			
			switch(string)
			{
				case "reverse":
					value = REVERSE;
					break;
				case "pingpong":
					value = PINGPONG;
					break;
			}
			
			return value;
		}
	}
}

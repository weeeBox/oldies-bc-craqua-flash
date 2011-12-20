package bc.core.motion 
{

	/**
	 * @author Elias Ku
	 */
	public class BcMotionKeyFlag 
	{
		public static var CLOSED_BEGIN:uint = 1;
		public static var CLOSED_END:uint = 2;
		public static var CLOSED:uint = CLOSED_BEGIN | CLOSED_END;
	}
}

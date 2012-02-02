package bc.core.display
{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author weee
	 */
	public class BcApplication
	{
		private static var display:Sprite = new Sprite();
		
		public static function get sharedDisplay():DisplayObjectContainer
		{
			return display;
		}
	}
}

package bc.core.display
{
	import bc.core.device.BcIApplication;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author weee
	 */
	public class BcApplication
	{
		private static const DISPLAY_WIDTH:uint = 640;
		private static const DISPLAY_HEIGHT:uint = 480;
		
		private static var display:Sprite = new Sprite();
		private static var application:BcIApplication;
		
		public static function get sharedDisplay():DisplayObjectContainer
		{
			return display;
		}
		
		public static function get width():uint
		{
			return DISPLAY_WIDTH;
		}
		
		public static function get height():uint
		{
			return DISPLAY_HEIGHT;
		}
		
		public static function get sharedApplication():BcIApplication
		{
			return application;
		}
		
		public static function set sharedApplication(value:BcIApplication):void
		{
			application = value;
		}
	}
}

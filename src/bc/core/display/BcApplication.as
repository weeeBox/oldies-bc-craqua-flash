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
		
		private static var m_mouseX:Number = 0;
		private static var m_mouseY:Number = 0;
		private static var m_mousePushed:Boolean;
		
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
		
		public static function get mouseX():Number 
		{
			return m_mouseX;
		}
		
		public static function set mouseX(value:Number):void 
		{
			m_mouseX = value;
		}
		
		public static function get mouseY():Number 
		{
			return m_mouseY;
		}
		
		public static function set mouseY(value:Number):void 
		{
			m_mouseY = value;
		}
		
		public static function get mousePushed():Boolean 
		{
			return m_mousePushed;
		}
		
		public static function set mousePushed(value : Boolean):void 
		{
			m_mousePushed = value;
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

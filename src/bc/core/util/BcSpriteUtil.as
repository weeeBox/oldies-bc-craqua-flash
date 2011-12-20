package bc.core.util 
{
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcSpriteUtil 
	{
		public static function setupFast(sprite:Sprite):void
		{
			sprite.mouseEnabled = false;
			sprite.mouseChildren = false;
			sprite.tabChildren = false;
			sprite.focusRect = false;
			sprite.useHandCursor = false;
		}
		
		public static function enableInteractive(sprite:Sprite):void
		{
			sprite.mouseEnabled = true;
			sprite.mouseChildren = true;
			sprite.tabChildren = true;
			sprite.focusRect = true;
			sprite.useHandCursor = true;
		}
	}
}

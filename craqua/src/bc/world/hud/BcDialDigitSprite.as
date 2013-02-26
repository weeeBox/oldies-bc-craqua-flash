package bc.world.hud 
{
	import bc.core.util.BcSpriteUtil;
	import bc.world.common.BcShadowSprite;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcDialDigitSprite extends Sprite 
	{
		public var shadow:BcShadowSprite;
		public var bitmap:Bitmap = new Bitmap();
		public var isNull:Boolean;
		
		public var flow:Number = 0;
		
		public function BcDialDigitSprite(enableShadow:Boolean = true)
		{
			BcSpriteUtil.setupFast(this);
			
			addChild(bitmap);
			
			if(enableShadow)
			{
				shadow = new BcShadowSprite(470);
				shadow.join();
			}
		}	
	}
}

package bc.world.common 
{
	import flash.display.PixelSnapping;
	import bc.core.util.BcSpriteUtil;
	import bc.game.BcGameGlobal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import bc.core.ui.UITextField;
	import bc.core.ui.UITextFieldAutoSize;
	//#if CUT_THE_CODE
	//# import flash.text.TextFormat;
	//#endif

	/**
	 * @author Elias Ku
	 */
	public class BcLevelMarker extends Sprite 
	{
		public var tf:UITextField = new UITextField();
//#if CUT_THE_CODE
//#		public var filter:DropShadowFilter = new DropShadowFilter(0, 0, 0x00284b, 1, 2, 2, 8, 2);
//#endif
		public var bitmap:Bitmap = new Bitmap();
		
		public var beginX:Number = 0;
		public var endX:Number = 0;
		public var tweenProgress:Number = 0;
		public var speed:Number = 0.25;
		
	
		public function BcLevelMarker()
		{
			BcSpriteUtil.setupFast(this);
//#if CUT_THE_CODE		
//#        	tf.defaultTextFormat = new TextFormat("main", 40, 0xffffff);
//#			tf.embedFonts = true;
//#			tf.selectable = false;
//#			tf.autoSize = UITextFieldAutoSize.LEFT;
//#			tf.textColor = 0xffffff;
//#			tf.filters = [filter];
//#			tf.cacheAsBitmap = true;
//#endif
			tf.x = 4;
			
			//addChild(tf);
			addChild(bitmap);
			scaleX = 
			scaleY = 0.99;
			//cacheAsBitmap = true;
			
			visible = false;
			y = 180;
		}
		
		public function update(dt:Number):void
		{
			if(parent)
			{
				tweenProgress+=dt;
				
				if(tweenProgress>=4)
				{
					parent.removeChild(this);
					visible = false;
				}
				else
				{
					x = easeOutInCubic(tweenProgress, beginX, endX - beginX, 4);
				}
			}
		}
		
		public function easeOutCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
		public function easeOutInCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d*0.5) return easeOutCubic (t*2, b, c*0.5, d);
			return easeInCubic((t*2)-d, b+c*0.5, c*0.5, d);
		}
		
	
		public function easeInCubic (t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*(t/=d)*t*t + b;
		}

		
		public function launch(text:String):void
		{
			tf.text = text;

			var bitmapData:BitmapData = new BitmapData(int(tf.width+5), int(tf.height+5), true, 0);

//#if CUT_THE_CODE			
//#			bitmapData.draw(tf, tf.transform.matrix);
//#endif
			bitmap.bitmapData = bitmapData;
			bitmap.smoothing = true;
			bitmap.pixelSnapping = PixelSnapping.NEVER;
			
			x = beginX = 644;
			endX = -tf.width - 4;
			tweenProgress = 0;
			BcGameGlobal.world.hud.background.addChild(this);
			visible = true;
		}
	}
}

package bc.world.hud 
{
	import bc.core.display.BcBitmapData;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcDialSprite extends Sprite 
	{
		private var digits:Vector.<BcDialDigitSprite>;
		
		private var animation:Number = 0;

		public function BcDialSprite(count:uint, enableShadows:Boolean = true)
		{
			BcSpriteUtil.setupFast(this);
			
			var i:uint;
			var x:Number = 0;
			var flow:Number = Math.random();
			
			digits = new Vector.<BcDialDigitSprite>(count, true);
			
			for( i = 0; i < count; ++i)
			{
				digits[i] = new BcDialDigitSprite(enableShadows);
				digits[i].x = x;
				digits[i].flow = flow;
				addChild(digits[i]);
				x+=16;
				flow+=0.1;
			}
		}
		
		public function setValue(value:uint):void
		{
			var rad:uint = 1;
			var dig:uint;
			const count:uint = digits.length;
			var i:int = count - 1;
			
			while(i>=0)
			{
				dig = ( value % (rad*10) ) / rad;
				digitBitmaps[dig].setupBitmap(digits[i].bitmap);
				digits[i].isNull = false;
				
				rad *= 10;
				--i;
			}
			
			rad /= 10;
			
			for (i = 0; i < count; ++i)
			{
				if(uint(value/rad)==0)
				{
					digits[i].isNull = true;
					rad /= 10;
				}
				else
					break;
			}
		}
		
		public function update(dt:Number, ox:Number, oy:Number):void
		{
			animation+=dt;
			if(animation>1)
				animation -= uint(animation);
				
			
			
			for each (var dig:BcDialDigitSprite in digits)
			{
				dig.flow += dt;
				if(dig.flow > 1)
					dig.flow -= uint(dig.flow);
				dig.y = 2*Math.sin(dig.flow*Math.PI*2);
				
				if(dig.isNull && dig.alpha > 0.5)
				{
					dig.alpha -= dt;
					if(dig.alpha < 0.5)
						dig.alpha = 0.5;
					
					if(dig.shadow) dig.shadow.alpha = dig.alpha;
				}
				else if( !dig.isNull && dig.alpha < 1)
				{
					dig.alpha += dt;
					if(dig.alpha > 1)
						dig.alpha = 1;
					
					if(dig.shadow) dig.shadow.alpha = dig.alpha;
				}
				
				if(dig.shadow)
				{
					dig.shadow.update(ox + x + dig.x, oy + y + dig.y, 32);
				}
			}
		}

		public static var digitBitmaps:Vector.<BcBitmapData> = new Vector.<BcBitmapData>(10, true);
		
		public static function initialize():void
		{
			var i:uint;
			for (i = 0; i < 10; ++i)
			{
				digitBitmaps[i] = BcBitmapData.getData("level_digit_" + i.toString());
			}
		}
	}
}

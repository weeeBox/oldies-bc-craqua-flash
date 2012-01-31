package bc.world.hud 
{
	import bc.core.display.BcBitmapData;
	import bc.core.util.BcSpriteUtil;
	import bc.world.common.BcShadowSprite;

	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcHudField extends Sprite 
	{
		private var icon:Sprite = new Sprite();
		private var decoration:Sprite = new Sprite();
		private var shadow:BcShadowSprite = new BcShadowSprite(470);
		
		private var baseY:Number = 450;
		
		private var dial:BcDialSprite;
		
		private var good:Number = 0;
		private var flow:Number = 0;
		
		public var iconRotation:Number = 0;
		public var shadowRotationOffset:Number = 0;
		public var shadowRotationK:Number = 0;
		
		
		public function BcHudField(x:Number, digits:uint, iconBitmap:String, decorationBitmap:String = null)
		{
			BcSpriteUtil.setupFast(this);
			BcSpriteUtil.setupFast(icon);
			BcSpriteUtil.setupFast(decoration);
			
			icon.addChild(BcBitmapData.create(iconBitmap));
			addChild(icon);
			if(decorationBitmap)
			{
				decoration = new Sprite();
				decoration.addChild(BcBitmapData.create(decorationBitmap));
				addChild(decoration);
			}
			
			shadow.join();
			
			this.x = x;
			y = baseY;
			
			dial = new BcDialSprite(digits, false);
			dial.setValue(0);
			dial.x = 32;
			dial.y = 4;
			addChild(dial);
		}
		
		public function initialize():void
		{
			dial.setValue(0);
			
			flow = Math.random();
			good = 0;
			
			updateAnimation();
			
		}
		
		public function update(dt:Number):void
		{
			var updateGood:Boolean;
			
			flow += dt*0.5*(1+good*4);
			if(flow > 1)
				flow -= int(flow);
			
			if(good > 0)
			{
				good -= dt * 4;
				if(good < 0)
					good = 0;
				
				updateGood = true;
			}
			
			updateAnimation(updateGood);
			
			dial.update(dt, x, y);
		}
		
		private function updateAnimation(goodAnimation:Boolean = true):void
		{
			var shadowOffset:Number = 0;
			
			if(goodAnimation)
			{
				if(decoration)
				{
					decoration.scaleX = 1 + good*0.2;
					decoration.scaleY = 1 + good*0.2;
				}
			}
			
			var a:Number = Math.sin(flow*Math.PI*4);
			icon.y = 2*Math.sin(flow*Math.PI*2);
			if(decoration)
			{
				decoration.y = icon.y;
			}
			icon.scaleX = (1+good*0.3)*(0.95 + a*0.05);
			icon.scaleY = (1+good*0.3)*(0.95 - a*0.05);
			
			if(iconRotation > 0)
			{
				icon.rotation = (1+Math.sin(flow*Math.PI*2))*iconRotation;
				shadowOffset = shadowRotationOffset - icon.rotation*shadowRotationK;
			}
				
			shadow.update(x + shadowOffset, y + icon.y, 32);
		}
		
		public function updateValue(value:uint):void
		{
			dial.setValue(value);
		}

		public function onGood():void
		{
			good = 1;
		}
	}
}

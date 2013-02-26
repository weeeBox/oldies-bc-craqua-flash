package bc.world.hud 
{
	import bc.core.display.BcBitmapData;
	import bc.core.util.BcColorTransformUtil;
	import bc.core.util.BcSpriteUtil;
	import bc.world.common.BcShadowSprite;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcHudBombSprite extends Sprite 
	{
		private var bomb:Sprite = new Sprite();
		private var shadow:BcShadowSprite = new BcShadowSprite(470);
		
		private var bombRotation:Number = 30;
		private var flow:Number = 0;
		
		private var used:Number = 0;
		public var empty:Boolean;
		
		private static var CT_NORMAL:ColorTransform = new ColorTransform();
		private static var CT_USED:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 0.5);
		private static var CT:ColorTransform = new ColorTransform();
		
		public function BcHudBombSprite()
		{
			BcSpriteUtil.setupFast(this);
			BcSpriteUtil.setupFast(bomb);
			
			bomb.addChild(BcBitmapData.create("level_bomb"));
			addChild(bomb);
			
			shadow.join();
			
			y = 445;
		}
		
		public function initialize(flow:Number):void
		{
			bombRotation = -10+Math.random()*20;
			used = 0;
			
			this.flow = flow;
			
			updateAnimation();
		}

		public function update(dt:Number):void
		{
			var updateUsed:Boolean;
			
			flow += dt*0.5;
			if(flow > 1)
				flow -= int(flow);
				
			if(empty && used < 1)
			{
				used += dt * 4;
				if(used > 1)
					used = 1;
				updateUsed = true;
			}
			else if(!empty && used > 0)
			{
				used -= dt * 4;
				if(used < 0)
					used = 0;
				updateUsed = true;
			}
				
			
			
			updateAnimation(updateUsed);
		}
		
		private function updateAnimation(animateUsed:Boolean = true):void
		{
			var a:Number = Math.sin(flow*Math.PI*2);
			
			bomb.y = 2*a;
			
			if(animateUsed)
			{
				bomb.transform.colorTransform = BcColorTransformUtil.lerpMult(CT, CT_NORMAL, CT_USED, used);
				shadow.alpha = 1 - 0.5*used;
			}
				
			shadow.update(x, y + bomb.y - 10, 24);
			
			bomb.rotation = bombRotation + Math.sin(flow*Math.PI*8)*7;
		}
		
	}
}

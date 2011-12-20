package bc.world.hud 
{
	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcHudBombs 
	{
		private var bombs:Vector.<BcHudBombSprite>;

		public function BcHudBombs(count:uint, layer:Sprite)
		{
			var i:uint;
			var bomb:BcHudBombSprite;
			var x:Number = (640 - ( (count-1)*24 + 64) )*0.5;
			bombs = new Vector.<BcHudBombSprite>(count, true);
			
			for(i=0; i<count; ++i)
			{
				bomb = new BcHudBombSprite();
				bomb.x = x;
				layer.addChild(bomb);
				bombs[i] = bomb;
				if(i==2)
				{
					x+=64;
				}
				x+=24;
			}
		}
		
		public function initialize():void
		{
			var flow:Number = Math.random();
			
			for each (var bomb:BcHudBombSprite in bombs)
			{
				bomb.empty = false;
				bomb.initialize(flow);
				
				flow += 0.1;
			}
		}
		
		public function update(dt:Number):void
		{
			for each (var bomb:BcHudBombSprite in bombs)
			{
				bomb.update(dt);
			}
		}
		
		public function onUse():void
		{
			var bomb:BcHudBombSprite;
			var i:int = bombs.length - 1;
			
			while(i>=0)
			{
				bomb = bombs[i];
				if(!bomb.empty)
				{
					bomb.empty = true;
					break;
				}
				--i;
			}
		}
		
		public function onRegen():void
		{
			var bomb:BcHudBombSprite;
			var i:int = 0;
			
			while(i < bombs.length)
			{
				bomb = bombs[i];
				if(bomb.empty)
				{
					bomb.empty = false;
					break;
				}
				++i;
			}
		}
		
		public function setValue(value:uint):void
		{
			var full:Boolean = value > 0;
			var count:int = value;
			var i:int = 0;
			
			while(i < bombs.length)
			{
				bombs[i].empty = !full;
				
				count -= 1;
				full = count > 0;

				++i;
			}
		}
	}
}

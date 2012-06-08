package bc.world.core 
{
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.core.math.Vector2;
	import bc.world.player.BcPlayer;

	import flash.geom.Rectangle;	
	import flash.ui.Mouse;

	/**
	 * @author Elias Ku
	 */
	public class BcInput
	{
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		
		public var bounds:Rectangle = new Rectangle();
		
		public var active:Boolean;
		
		public virtual function update(dt:Number):void
		{			
		}
		
		public virtual function reset():void
		{				
		}

		public function keyboard(message:BcKeyboardMessage):void
		{			
		}
		
		public function mouse(message:BcMouseMessage):void
		{			
			mouseX = message.x - bounds.x;
			mouseY = message.y - bounds.y;
		}
		
		public function activate(value:Boolean):void
		{
			active = value;
			Mouse.show();
			reset();
		}

	}
}

package bc.world.core 
{
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.core.math.Vector2;
	import bc.world.player.BcPlayer;

	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;

	/**
	 * @author Elias Ku
	 */
	public class BcInput
	{
		public var direction:Vector2 = new Vector2();
		
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		
		public var bounds:Rectangle = new Rectangle();
		
		public var player:BcPlayer;
		
		public var active:Boolean;
		
		public var hideCounter:Number = 0;
		
		public function BcInput(player:BcPlayer)
		{
			this.player = player;
		}
		
		public function update(dt:Number):void
		{
			var mx:Number = mouseX;
			var my:Number = mouseY;
			
			if(active)
			{
				if(mx<0) mx = 0;
				else if(mx > bounds.width) mx = bounds.width;
				
				if(my<0) my = 0;
				else if(my > bounds.height) my = bounds.height;
				
				direction.x = mx - player.position.x;
				direction.y = my - player.position.y;
				
				hideCounter -= dt;
				if(hideCounter <= 0)
				{
					Mouse.hide();
					hideCounter = 1;
				}
				
				player.moveDirection.copy(direction);
			
			}
		}
		
		public function reset():void
		{
			hideCounter = 1;
	
			player.moveDirection.setZero();
			player.shotTrigger = false;	
		}

		public function keyboard(message:BcKeyboardMessage):void
		{
			if(message.event == BcKeyboardMessage.KEY_DOWN &&
			   message.key == Keyboard.SPACE && 
			   !message.repeated)
			{
				player.launchBomb();
			}
		}
		
		public function mouse(message:BcMouseMessage):void
		{
			switch(message.event)
			{
				case BcMouseMessage.MOUSE_DOWN:
					player.shotTrigger = true;
					break;
				case BcMouseMessage.MOUSE_UP:
					player.shotTrigger = false;
					break;
			}
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

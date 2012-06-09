package bc.world.input
{
	import bc.flash.events.GamePadEvent;
	import bc.flash.input.GamePad;
	import bc.core.device.messages.BcGamePadMessage;
	import bc.core.device.messages.BcMouseMessage;
	import flash.ui.Keyboard;
	import bc.core.device.messages.BcKeyboardMessage;
	import flash.ui.Mouse;
	import bc.world.player.BcPlayer;	
	import bc.core.math.Vector2;
	
	/**
	 * @author weee
	 */
	public class BcPlayerInput extends BcInput
	{
		public static const STICK_SPEED_X:Number = 7.5;
		public static const STICK_SPEED_Y:Number = -7.5;
		
		public var direction:Vector2 = new Vector2();
		
		public var player:BcPlayer;
		
		public var hideCounter:Number = 0;
		
		public function BcPlayerInput(player:BcPlayer)
		{
			this.player = player;
		}
		
		public override function update(dt:Number):void
		{
			mouseX += GamePad.player(0).leftStick.x * STICK_SPEED_X;
			mouseY += GamePad.player(0).leftStick.y * STICK_SPEED_Y;
			
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
		
		public override function reset():void
		{
			hideCounter = 1;
	
			player.moveDirection.setZero();
			player.shotTrigger = false;	
		}

		public override function keyboard(message:BcKeyboardMessage):void
		{
			if(message.event == BcKeyboardMessage.KEY_DOWN &&
			   message.key == Keyboard.SPACE && 
			   !message.repeated)
			{
				player.launchBomb();
			}
		}
		
		public override function mouse(message:BcMouseMessage):void
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
		
		public override function gamepad(message:BcGamePadMessage):void
		{
			switch(message.event)
			{
				case BcGamePadMessage.BUTTON_DOWN:
					if (message.code == GamePadEvent.A)
					{
						player.shotTrigger = true;
					}
					break;
				case BcGamePadMessage.BUTTON_UP:
					if (message.code == GamePadEvent.A)
					{
						player.shotTrigger = false;
					}
					break;
			}
		}
		
		public override function activate(value:Boolean):void
		{
			active = value;
			Mouse.show();
			reset();
		}
	}
}

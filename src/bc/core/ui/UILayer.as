package bc.core.ui 
{
	import bc.core.display.BcApplication;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;

	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class UILayer extends UIObject
	{
		public function UILayer()
		{
			super(null, 0, 0, false);
			
			_sprite.scrollRect = new Rectangle(0, 0, BcApplication.width, BcApplication.height);
		}
		
		public override function update():void
		{
			if(_active)
			{
				super.update();
			}
		}
		
		internal function setNext(layer:UILayer):void
		{
			_next = layer;
		}
		
		internal function keyboardMessage(message:BcKeyboardMessage):void
		{
		}
		
		internal function mouseMessage(message:BcMouseMessage):void
		{
			const x:Number = message.x;
			const y:Number = message.y;
			
			if(_enabled)
			{
				switch(message.event)
				{
					case BcMouseMessage.MOUSE_MOVE:
						mouseMove(x, y);
						break;
					case BcMouseMessage.MOUSE_UP:
						mouseUp(x, y);
						break;
					case BcMouseMessage.MOUSE_DOWN:
						mouseDown(x, y);
						break;						
				}
			}
		}
		
	}
}

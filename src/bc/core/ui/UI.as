package bc.core.ui 
{
	import bc.core.device.BcDevice;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;

	/**
	 * @author Elias Ku
	 */
	public class UI 
	{
		private static var _layers:UILayer;
		private static var _deltaTime:Number = 0;
		
		public static function get deltaTime():Number
		{
			return _deltaTime;
		}
						
		public static function update(dt:Number):void
		{
			var iter:UIObject = _layers;
			
			_deltaTime = dt;
			
			while(iter)
			{
				iter.update();
				iter = iter.next;
			}
		}
				
		public static function keyboardMessage(message:BcKeyboardMessage):void
		{
			var iter:UILayer = _layers;
			
			while(iter)
			{
				iter.keyboardMessage(message);
				iter = UILayer(iter.next);
			}
		}
		
		public static function mouseMessage(message:BcMouseMessage):void
		{
			var iter:UILayer = _layers;
			
			while(iter)
			{
				iter.mouseMessage(message);
				iter = UILayer(iter.next);
			}
		}
	
		public static function addLayer(layer:UILayer):void
		{
			if(!layer.sprite.parent)
			{
				BcDevice.display.addChild(layer.sprite);
				layer.setNext(_layers);
				_layers = layer;
			}
			else throw new Error("EkUI: Window hasn't ID.");
		}
		
	}
}

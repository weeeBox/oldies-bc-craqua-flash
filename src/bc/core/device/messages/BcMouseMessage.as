package bc.core.device.messages 
{

	import flash.events.MouseEvent;
	/**
	 * @author Elias Ku
	 */
	public class BcMouseMessage 
	{
		public static const MOUSE_MOVE:uint = 0;
		public static const MOUSE_DOWN:uint = 1;
		public static const MOUSE_UP:uint = 2;
		
		public var event:uint;
		
		public var x:Number;
		public var y:Number;
		
		public function BcMouseMessage() {}
		
		public function processEvent(eventType:uint, mouseEvent:MouseEvent):void
		{
			event = eventType;
			x = mouseEvent.stageX;
			y = mouseEvent.stageY;
		}
	}
}

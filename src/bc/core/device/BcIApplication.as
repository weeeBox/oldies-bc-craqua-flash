package bc.core.device 
{

	import bc.core.device.messages.BcGamePadMessage;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	/**
	 * @author Elias Ku
	 */
	public interface BcIApplication 
	{
		function update(dt:Number):void;
		function activate(active:Boolean):void;
		
		function mouseMessage(message:BcMouseMessage):void;
		function keyboardMessage(message:BcKeyboardMessage):void;
		function gamePadMessage(message:BcGamePadMessage):void;
		
		function contextMenu():void;
	}
}

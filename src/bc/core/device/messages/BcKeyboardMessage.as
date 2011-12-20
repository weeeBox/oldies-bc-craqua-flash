package bc.core.device.messages 
{

	import flash.events.KeyboardEvent;
	/**
	 * @author Elias Ku
	 */
	public class BcKeyboardMessage 
	{		
		public static var KEY_DOWN:uint = 0;
		public static var KEY_UP:uint = 1;
		
		public var event:uint;
		
		public var alt:Boolean;
		public var ctrl:Boolean;
		public var shift:Boolean;
		public var repeated:Boolean;
		
		public var key:uint;
		public var char:uint;
		public var location:uint;
		
		public function BcKeyboardMessage() {}
		
		public function processEvent(eventType:uint, repeated:Boolean, keyboardEvent:KeyboardEvent):void
		{
			event = eventType;
			
			alt = keyboardEvent.altKey;
			ctrl = keyboardEvent.ctrlKey;
			shift = keyboardEvent.shiftKey;
			this.repeated = repeated;
			
			key = keyboardEvent.keyCode;
			char = keyboardEvent.charCode;
			location = keyboardEvent.keyLocation;
		}
	}
}

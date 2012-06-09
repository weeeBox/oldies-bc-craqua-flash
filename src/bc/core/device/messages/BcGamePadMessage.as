package bc.core.device.messages
{
	import bc.flash.events.GamePadEvent;
	/**
	 * @author weee
	 */
	public class BcGamePadMessage
	{
		public static const BUTTON_DOWN:uint = 0;
		public static const BUTTON_UP:uint = 1;
		
		public var mEventType:uint;
		public var mCode:uint;		
		public var mPlayerIndex:uint;
		
		public function processEvent(eventType:uint, event:GamePadEvent):void
		{
			mEventType = eventType;
			mCode = event.code;
			mPlayerIndex = event.playerIndex;
		}
		
		public function get event() : uint
		{
			return mEventType;
		}
		
		public function get code() : uint
		{
			return mCode;
		}
		
		public function get playerIndex() : uint
		{
			return mPlayerIndex;
		}
	}
}

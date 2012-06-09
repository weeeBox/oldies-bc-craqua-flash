package bc.core.device 
{
	import bc.core.device.messages.BcGamePadMessage;
	import bc.core.display.BcApplication;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	/**
	 * @author Elias Ku
	 */
	public class BcGamePreloaderBase implements BcIApplication 
	{
		internal var _loaderEntry:BcEntryPoint;
		private var _mainEntry:String;
		
		private var _fake:Number = 0;
		protected var _fakeSpeed:Number = 2;
		
		protected var _progress:Number = 0;
		protected var _completed:Boolean;
		
		public function BcGamePreloaderBase(loaderEntry:BcEntryPoint, mainEntryClassName:String)
		{
			_loaderEntry = loaderEntry;
			_mainEntry = mainEntryClassName;
		}
		
		// Стартует прелоадинг
		protected function start():void
		{
			BcApplication.sharedApplication = this;
		}
		
		protected function finish():void
		{
			BcApplication.sharedApplication = null;
			_loaderEntry.nextEntryPoint(_mainEntry);
		}
		
		public function update(dt:Number):void
		{			
			if(_fake < 1)
	    	{
	    		_fake += _fakeSpeed*dt;
	    		if(_fake > 1)
	    		{
	    			_fake = 1;
	    		}
	    	}
	    	
	    	_progress = _fake * _loaderEntry.loadingProgress;
	    	_completed = (_fake>=1 && _loaderEntry.loadingCompleted);
		}
		
		public function activate(active:Boolean):void
		{
		}
		
		public function mouseMessage(message:BcMouseMessage):void
		{
		}
		
		public function keyboardMessage(message:BcKeyboardMessage):void
		{
		}
		
		public function gamePadMessage(message : BcGamePadMessage) : void
		{
		}
		
		public function contextMenu():void
		{
		}
	}
}

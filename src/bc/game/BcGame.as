package bc.game 
{
	import bc.core.display.BcApplication;
	import bc.core.audio.BcAudio;
	import bc.core.data.BcData;
	import bc.core.device.BcIApplication;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.ui.BcGameUI;
	import bc.world.core.BcWorld;

	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;

	/**
	 * @author Elias Ku
	 */
	public class BcGame implements BcIApplication
	{
		private var world:BcWorld;
//#if CUT_THE_CODE
//#		private var so:SharedObject;
//#endif
		private var mc:MovieClip;
		
		public function BcGame()
		{
			if(!BcGameGlobal.game)
			{
				initializeLocalStore();
				
				BcGameGlobal.game = this;
				
				BcAudio.configurate("audio_data");
				//BcBitmapData.load("prop_bitmaps");
				BcData.load(Vector.<String>(["music", "prop_bitmaps", "audio_data"]));
				
				world = new BcWorld();
				BcApplication.sharedApplication = this;				
				
				BcGameUI.instance.loadingComplete();
				
				if(BcGameUI.instance.oMochiHS)
				{
					//mc = new MovieClip();
					//BcDevice.display.addChild(mc);
					//MochiServices.connect("c3eee4897b802b27", mc);
				}
			}
		}
		
		public function startNewGame():void
		{
			world.start(true);
		}
		
		public function startLastCheckPoint():void
		{
			world.start(false);
		}
		
		public function update(dt:Number):void
		{			
			if(world.playing)
			{
				world.update(dt);
			}
		}
		
		public function activate(active:Boolean):void
		{
			if(world.playing && !active)
			{
				pausePlaying();
			}
		}
		
		public function resumePlaying():void
		{
			if(world.pause == true)
			{
				world.pause = false;
			}
		}
		
		public function pausePlaying():void
		{
			if(world.pause == false)
			{
				world.pause = true;
				BcGameUI.instance.goPause();
			}
		}
		
		public function quitWorld():void
		{
			world.exit();
			Mouse.show();
		}
				
		public function contextMenu():void
		{
			if(world.playing)
			{
				pausePlaying();
			}
		}
		
		public function mouseMessage(message:BcMouseMessage):void
		{
			if(world.playing)
			{
				world.mouseMessage(message);
			}
		}
		
		public function keyboardMessage(message:BcKeyboardMessage):void
		{
			if(world.playing)
			{
				world.keyboardMessage(message);
				if(message.event==BcKeyboardMessage.KEY_DOWN && message.key == Keyboard.ESCAPE && !message.repeated)
				{
					pausePlaying();
				}
			}
		}
		
		private function initializeLocalStore():void
		{
//#if CUT_THE_CODE
//#			so = SharedObject.getLocal("bc20");
//#			
//#			if(so)
//#			{
//#				BcGameGlobal.localStore = so.data;
//#				if(so.data.name == null)
//#				{
//#					so.data.name = "unnamed";
//#					so.data.best = 0;
//#				}
//#			}
//#			else
//#endif
			{
				BcGameGlobal.localStore = new Object();
			}
		}
		
	}
}

internal class PrivateContructor {} 

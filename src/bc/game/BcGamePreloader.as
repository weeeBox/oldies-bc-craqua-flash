package bc.game 
{
	import bc.core.data.BcData;
	import bc.core.device.BcEntryPoint;
	import bc.core.device.BcPreloader;
	import bc.ui.BcGameUI;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcGamePreloader extends BcPreloader 
	{

		public function BcGamePreloader(loaderEntry:BcEntryPoint)
		{
			super(loaderEntry, "bc.game.init.BitCaptains");
			
			_fakeSpeed = 0.3;
			
			BcData.load(Vector.<String>(["data"]));
			//sprite = new BcPreloaderSprite();
			//BcDevice.display.addChild(sprite);
			
			//wndBG = new BcBackgroundWindow();
			//BcUI.instance.addWindow(wndBG, 0);
			//wndBG.open(true);
			
			new BcGameUI();
			
			start();
		}
		
		public override function update(dt:Number):void
		{			
			super.update(dt);
			
			//sprite.progress = _progress;
			//sprite.update(dt);
			BcGameUI.instance.loading(_progress);
			
			if(_completed)
			{
				finish();
			}
		}
	}
}

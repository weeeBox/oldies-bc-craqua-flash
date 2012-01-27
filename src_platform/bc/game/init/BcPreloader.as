package bc.game.init 
{
	import bc.core.device.BcDevice;
	import bc.core.device.BcEntryPoint;
	import bc.game.asset.BcPreloaderAsset;

	/**
	 * @author Elias Ku
	 */
	
	public class BcPreloader extends BcEntryPoint 
	{
		public function BcPreloader()
		{
			super();
			
			BcDevice.initialize(stage);
			
			if(BcDevice.impl)
				new BcPreloaderAsset(initialize);
		}
		
		private function initialize():void
		{
			new BcGamePreloader(this);
		}
		
	}
}

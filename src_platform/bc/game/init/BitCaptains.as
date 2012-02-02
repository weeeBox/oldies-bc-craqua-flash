package bc.game.init 
{
	import bc.core.device.BcAssetCallback;
	import bc.core.device.BcEntryPoint;
	import bc.game.BcGame;
	import bc.game.asset.BcGameLoader;

	/**
	 * @author Elias Ku
	 */
	 
	[Frame(factoryClass="bc.game.init.BcPreloader")]
	[SWF(backgroundColor="#000000", width="640", height="480")] 
	public class BitCaptains extends BcEntryPoint implements BcAssetCallback
	{
		public function BitCaptains()
		{
			new BcGameLoader(this);
		}
		
		public function assetLoadingCompleted() : void
		{
			new BcGame();
		}
	}
}

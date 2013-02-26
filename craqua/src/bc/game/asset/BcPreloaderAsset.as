package bc.game.asset 
{
	import bc.core.device.BcAssetCallback;
	import bc.core.device.BcAsset;

	/**
	 * @author Elias Ku
	 */
	public class BcPreloaderAsset
	{
		public function BcPreloaderAsset(callback:BcAssetCallback)
		{
			BcAsset.loadPath("../asset/preloader.xml", callback);
			//callback();
		}
	}
}

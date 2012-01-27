package bc.game.init 
{
	import bc.core.device.BcEntryPoint;
	import bc.game.BcGame;
	import bc.game.asset.BcGameAsset;

	/**
	 * @author Elias Ku
	 */
	 
	[Frame(factoryClass="bc.game.init.BcPreloader")]
	[SWF(backgroundColor="#000000", width="640", height="480")] 
	public class BitCaptains extends BcEntryPoint 
	{
		public function BitCaptains()
		{
			super();
			
			new BcGameAsset(initialize);
		}
		
		private static function initialize():void
		{
			new BcGame();
		}
	}
}

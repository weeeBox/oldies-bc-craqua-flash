package bc.game.asset 
{
	import bc.core.device.BcAsset;

	/**
	 * @author Elias Ku
	 */
	public class BcPreloaderAsset
	{
		[Embed(source="../../../../asset/preloader/main.ttf", fontName="main", embedAsCFF="false")]
        private var fntGROBOLD:Class;
        
       /* [Embed(source="../../../../asset/preloader/ui/bg_.jpg")]
		private static var img_ui_bg:Class;
		BcAsset.embedImage("ui_bg", img_ui_bg, false);
		
		[Embed(source="../../../../asset/preloader/sponsor/logo.png")]
		private static var img_sponsor_logo:Class;
		BcAsset.embedImage("sponsor_logo", img_sponsor_logo, true);
		
		[Embed(source="../../../../asset/preloader/sponsor/logo_back.png")]
		private static var img_sponsor_logo_back:Class;
		BcAsset.embedImage("sponsor_logo_back", img_sponsor_logo_back, true);
		
		[Embed(source="../../../../asset/preloader/data.xml", mimeType="application/octet-stream")]
		private static var xml_data:Class;
		BcAsset.embedXML("data", xml_data);*/
		        
		public function BcPreloaderAsset(callback:Function)
		{
			BcAsset.loadPath("../asset/preloader.xml", callback);
			//callback();
		}
	}
}

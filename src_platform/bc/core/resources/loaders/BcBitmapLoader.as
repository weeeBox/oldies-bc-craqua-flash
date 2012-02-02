package bc.core.resources.loaders
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import bc.core.resources.BcResLoaderListener;

	/**
	 * @author weee
	 */
	public class BcBitmapLoader extends BcResLoader
	{
		private var loader : Loader;
		private var hasAlpha : Boolean;
		
		public function BcBitmapLoader(id : String, path : String, listener : BcResLoaderListener)
		{
			super(BcResLoaderFactory.LOADER_IMAGE, id, path, listener);
			checkAlpha(path);
		}
		
		private function checkAlpha(path : String) : void
		{
			var dotIndex : int = path.lastIndexOf(".");
			var markerCharIndex : int = dotIndex == -1 ? path.length - 1 : dotIndex - 1;
			hasAlpha = path.charAt(markerCharIndex) != "_";
		}
		
		override public function load() : void
		{
			var request : URLRequest = new URLRequest(path);

			try
			{			
				loader = new Loader();
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete, false, 0, true);
			}
			catch (error : Error)
			{
				loader = null;
				doFail();
			}
		}
		
		private function onImageComplete(event : Event) : void
		{
			var bitmap : Bitmap = Bitmap(loader.content);
			var bitmapData : BitmapData = processBitmapData(bitmap.bitmapData, hasAlpha);
			loader = null;
			doFinish(bitmapData);						
		}
		
		private function onError(event : IOErrorEvent) : void
		{
			trace("Bitmap loading failed: " + event.text);
			
			loader = null;
			doFail();	
		}
		
		private function processBitmapData(bitmapData:BitmapData, alpha:Boolean):BitmapData
		{
			var bd:BitmapData = bitmapData;
			var temp:BitmapData;
			
			if(!alpha)
			{
				id = id.substring(0, id.length - 1);
				temp = new BitmapData(bd.width, bd.height, false, 0);
				temp.draw(bd);
				bd = temp;
				temp = null;
			}
			
			return bd;
		}
	}
}

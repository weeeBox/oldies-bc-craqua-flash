package bc.core.resources.loaders
{
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import bc.core.resources.BcResLoaderListener;
	import flash.net.URLLoader;

	/**
	 * @author weee
	 */
	public class BcXmlLoader extends BcResLoader
	{
		private var loader : URLLoader;
		
		public function BcXmlLoader(id : String, path : String, listener : BcResLoaderListener)
		{
			super(BcResLoaderFactory.LOADER_XML, id, path, listener);
		}
		
		override public function load() : void
		{
			var request : URLRequest = new URLRequest(path);

			try
			{			
				loader = new URLLoader();
				loader.load(request);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
				loader.addEventListener(Event.COMPLETE, onXMLComplete, false, 0, true);
			}
			catch (error : Error)
			{
				loader = null;
				doFail();
			}
		}
		
		private function onXMLComplete(event : Event) : void
		{
			var xml : XML = XML(loader.data);
			loader = null;
			doFinish(xml);
		}
		
		private function onError(event : IOErrorEvent) : void
		{
			loader = null;
			doFail();
		}
	}
}

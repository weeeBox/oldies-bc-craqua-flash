package bc.core.device 
{
	import flash.utils.Dictionary;
	import bc.core.debug.BcDebug;
	import bc.core.resources.loaders.BcResLoaderFactory;
	import bc.core.resources.loaders.BcResLoader;
	import bc.core.resources.BcResLoaderListener;
	import flash.display.BitmapData;
	import flash.media.Sound;

	/**
	 * @author Elias Ku
	 */
	public class BcAsset implements BcResLoaderListener
	{	
		public static function getImage(id:String):BitmapData
		{
			return BitmapData(images[id]);
		}
		
		public static function getSound(id:String):Sound
		{
			return Sound(sounds[id]);
		}
		
		public static function getXML(id:String):XML
		{
			return XML(xmls[id]);
		}
		
		public static function removeXML(id:String):void
		{
			delete xmls[id];
		}
			
		public static function loadPath(path:String, assetCallback:BcAssetCallback):void
		{
			instance.load(path, assetCallback);
		}
		
		internal static function get busy():Boolean
		{
			return instance.busyCounter > 0;
		}
		
		internal static function initialize():void
		{
			instance = new BcAsset(new BcAssetSingleton());
		}
		
		public static function getInstance() : BcAsset
		{
			return instance;
		}
		
		private static var XML_DEST_ID : String = "__desc";
		
		// Коллекции ресурсов, разделены по типам
		private static var images:Dictionary = new Dictionary();
		private static var xmls:Dictionary = new Dictionary();
		private static var sounds:Dictionary = new Dictionary();
		
		private static var instance:BcAsset;
		
		// Массив загрузчиков, чистится при завершении загрузки
		private var loaders:Vector.<BcResLoader>;
		private var activeLoaders:uint;
		public var busyCounter:uint;
		
		private var loadingCallback:BcAssetCallback;
		
		public function BcAsset(singleton:BcAssetSingleton)
		{
			if(singleton)
			{
				loaders = new Vector.<BcResLoader>();
			}
		}
		
		public function load(path:String, loadingCallback:BcAssetCallback):void
		{
			this.loadingCallback = loadingCallback;
			var loader:BcResLoader = createLoader(XML_DEST_ID, path, this);
			busyCounter++;
			loader.load();
		}

		private function createLoader(id:String, path:String, listener:BcResLoaderListener):BcResLoader
		{
			var loader : BcResLoader = BcResLoaderFactory.getInstance().createLoader(id, path, listener);
			
			loaders.push(loader);
			++activeLoaders;
			
			return loader;
		}
		
		private function releaseLoader():void
		{
			--activeLoaders;
			if(activeLoaders==0)
			{
				loaders.length = 0;
				busyCounter--;
				if(loadingCallback!=null)
				{
					loadingCallback.assetLoadingCompleted();
					loadingCallback = null;
				}
			}
		}
		
		private function parseDescription(xml:XML):void
		{
			var path_full:String = xml.attribute("path");
			var resources:XMLList = xml.elements("resource");

			for each (var res_node:XML in resources)
			{
				parseResource(res_node, path_full);
			}
		}

		private function parseResource(xml:XML, assetPath:String):void
		{
			var id:String;
			var path:String;
			var ext:String;
			
			path = assetPath + xml.attribute("path");
			id = xml.attribute("path");
			
			ext = id.substr(id.length-4);
			id = id.slice(0, id.length-4);
			
			id = removePathSeparators(id);
		
			createLoader(id, path, this).load();			
		}
			
		private function removePathSeparators(id : String) : String
		{
			var index : int;
			while ((index = id.indexOf("/")) != -1)
			{
				id = id.replace("/", "_");				
			}			
			while ((index = id.indexOf("\\")) != -1)
			{
				id = id.replace("\\", "_");
			}
			return id;
		}

		public function resLoadingComplete(loader : BcResLoader, data : Object) : void
		{
			var id : String = loader.getId();
			
			if (loader.getType() == BcResLoaderFactory.LOADER_IMAGE)
			{
				images[id] = BitmapData(data);
			}
			else if (loader.getType() == BcResLoaderFactory.LOADER_XML)
			{
				var xml : XML = XML(data);
				if (id == XML_DEST_ID)
				{
					parseDescription(xml);
				}
				else
				{
					xmls[id] = xml;
				}
			}
			else if (loader.getType() == BcResLoaderFactory.LOADER_SOUND)
			{
				sounds[id] = Sound(data);
			}
			
			releaseLoader();
		}

		public function resLoadingFailed(loader : BcResLoader) : void
		{
			BcDebug.assert(false);
		}
	}
}

internal class BcAssetSingleton 
{
}

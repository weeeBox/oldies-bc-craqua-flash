package bc.core.device 
{
	import flash.display.BitmapData;
	import flash.media.Sound;

	/**
	 * @author Elias Ku
	 */
	public class BcAsset 
	{	
		public static function getImage(id:String):BitmapData
		{
			return images[id];
		}
		
		public static function getSound(id:String):Sound
		{
			return sounds[id];
		}
		
		public static function getXML(id:String):XML
		{
			return xmls[id];
		}
		
		public static function removeXML(id:String):void
		{
			delete xmls[id];
		}
		
		public static function loadPath(path:String, onLoadingCompleted:Function):void
		{
			impl.load(path, onLoadingCompleted);
		}
		
		private static function processBitmapData(bitmapData:BitmapData, alpha:Boolean):BitmapData
		{
			var bd:BitmapData = bitmapData;
			var temp:BitmapData;
			
//#if CUT_THE_CODE
//#			if(!alpha)
//#			{
//#				temp = new BitmapData(bd.width, bd.height, false, 0);
//#				temp.draw(bd);
//#				bd = temp;
//#				temp = null;
//#			}
//#endif
			
			return bd;
		}
		
		internal static function get busy():Boolean
		{
			return impl.busyCounter > 0;
		}
		
		internal static function initialize():void
		{
			impl = new BcAsset(new BcAssetSingleton());
		}
		
		// Коллекции ресурсов, разделены по типам
		private static var images:Object = new Object();
		private static var xmls:Object = new Object();
		private static var sounds:Object = new Object();
		
		private static var impl:BcAsset;
		
		// Массив загрузчиков, чистится при завершении загрузки
		private var loaders:Vector.<BcLoader>;
		private var activeLoaders:uint;
		public var busyCounter:uint;
		
		private var loadingCompleted:Function;
		
		public function BcAsset(singleton:BcAssetSingleton)
		{
			if(singleton)
			{
				loaders = new Vector.<BcLoader>();
			}
		}
		
		
		
		public function load(path:String, onLoadingCompleted:Function):void
		{
			loadingCompleted = onLoadingCompleted;
			createLoader(BcLoader.LOADER_XML, "__desc", path, onDescriptionLoaded);
			busyCounter++;
		}

		private function createLoader(type:String, id:String, source:String, _complete:Function):BcLoader
		{
			var loader:BcLoader = new BcLoader(type, id, source, _complete);
			
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
				if(loadingCompleted!=null)
				{
					loadingCompleted();
					loadingCompleted = null;
				}
			}
		}
		
		private function onDescriptionLoaded(loader:BcLoader):void
		{
			var desc:XML = loader.xml;
			
			if(desc)
			{
				parseDescription(desc);
			}
			
			releaseLoader();
		}
		
		private function onResourceLoaded(loader:BcLoader):void
		{
			switch(loader.type)
			{
				case BcLoader.LOADER_IMAGE:
					images[loader.id] = processBitmapData(loader.bitmapData, loader.metaAlpha);
					break;
				case BcLoader.LOADER_XML:
					xmls[loader.id] = loader.xml;
					break;
				case BcLoader.LOADER_SOUND:
					sounds[loader.id] = loader.sound;
					break;
			}
			
			releaseLoader();
		}
		
		private function parseDescription(xml:XML):void
		{			
			var path_full:String = xml.@path.toString();

			for each (var res_node:XML in xml.resource)
			{
				parseResource(res_node, path_full);
			}
		}

		private function parseResource(xml:XML, assetPath:String):void
		{
			var id:String;
			var path:String;
			var ext:String;
			var alpha:Boolean = true;
			var loader:BcLoader;
			
			
			path = assetPath + xml.@path.toString();
			id = xml.@path.toString();
			
			ext = id.substr(id.length-4);
			id = id.slice(0, id.length-4);
			
			if(id.charAt(id.length-1) == "_")
			{
				alpha = false;
				id = id.slice(0, id.length-1);
			}
			
			while (id.indexOf("/") != -1)
			{
				id = id.replace("/", "_");				
			}			

//#if CUT_THE_CODE		
//#			switch(ext)
//#			{
//#				case ".png":
//#				case ".jpg":
//#					loader = createLoader(BcLoader.LOADER_IMAGE, id, path, onResourceLoaded);
//#					loader.metaAlpha = alpha;
//#					break;
//#				case ".mp3":
//#				case ".wav":
//#					createLoader(BcLoader.LOADER_SOUND, id, path, onResourceLoaded);
//#					break;
//#				case ".xml":
//#					createLoader(BcLoader.LOADER_XML, id, path, onResourceLoaded);
//#					break;
//#				default:
//#					throw new Error("BcAsset: unknown resource type.");
//#					break;
//#			}
//#endif
		}
		
		
	}
}

internal class BcAssetSingleton 
{
}

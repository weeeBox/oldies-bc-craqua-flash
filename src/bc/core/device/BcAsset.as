package bc.core.device 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author Elias Ku
	 */
	public class BcAsset 
	{	
		public static function addImage(id:String, bitmapData:BitmapData):void
		{
			images[id] = bitmapData;
		}
		
		public static function getImage(id:String):BitmapData
		{
			return images[id];
		}
		
		public static function embedImage(id:String, cls:Class, alpha:Boolean):void
		{
			images[id] = processBitmapData(Bitmap(new cls()).bitmapData, alpha);
		}
		
		public static function removeImage(id:String):void
		{
			delete images[id];
		}
		
		public static function addSound(id:String, sound:Sound):void
		{
			sounds[id] = sound;
		}
		
		public static function getSound(id:String):Sound
		{
			return sounds[id];
		}
		
		public static function embedSound(id:String, cls:Class):void
		{
			sounds[id] = Sound(new cls());
		}
		
		public static function removeSound(id:String):void
		{
			delete sounds[id];
		}
		
		public static function addXML(id:String, xml:XML):void
		{
			xmls[id] = xml;
		}	
				
		public static function getXML(id:String):XML
		{
			return xmls[id];
		}
		
		public static function embedXML(id:String, cls:Class):void
		{
			var ba:ByteArray = (new cls()) as ByteArray;
			xmls[id] = XML(ba.readUTFBytes(ba.length));
		}
		
		public static function removeXML(id:String):void
		{
			delete xmls[id];
		}
		
		public static function load(path:String, onLoadingCompleted:Function):void
		{
			impl.load(path, onLoadingCompleted);
		}
		
		private static function processBitmapData(bitmapData:BitmapData, alpha:Boolean):BitmapData
		{
			var bd:BitmapData = bitmapData;
			var temp:BitmapData;
			
			if(!alpha)
			{
				temp = new BitmapData(bd.width, bd.height, false, 0);
				temp.draw(bd);
				bd = temp;
				temp = null;
			}
			
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
			var res_node:XML;
			var path_full:String = xml.@path.toString();

			for each (res_node in xml.resource)
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
		
			switch(ext)
			{
				case ".png":
				case ".jpg":
					loader = createLoader(BcLoader.LOADER_IMAGE, id, path, onResourceLoaded);
					loader.metaAlpha = alpha;
					break;
				case ".mp3":
				case ".wav":
					createLoader(BcLoader.LOADER_SOUND, id, path, onResourceLoaded);
					break;
				case ".xml":
					createLoader(BcLoader.LOADER_XML, id, path, onResourceLoaded);
					break;
				default:
					throw new Error("BcAsset: unknown resource type.");
					break;
			}
		}
		
		
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;

internal class BcAssetSingleton 
{
}

internal class BcLoader
{
	public static const LOADER_IMAGE:String = "image";
	public static const LOADER_SOUND:String = "sound";
	public static const LOADER_XML:String = "xml";
	
	public var id:String;
	public var type:String;
	public var path:String;
	
	private var loader:Object;
	private var data:Object;
	private var callback:Function;
	
	public var metaAlpha:Boolean = true;
	
	public function BcLoader(type:String, id:String, path:String, callback:Function)
	{
		this.type = type;
		this.path = path;
		this.id = id;
		this.callback = callback;
		
		var request:URLRequest = new URLRequest(path);
		
		try
		{
			switch(type)
			{
				case LOADER_IMAGE:
					loader = new Loader();
            		loader.load(request);
            		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete, false, 0, true);
            		break;
            		
				case LOADER_SOUND:
					loader = new Sound();
            		loader.load(request);
            		loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            		loader.addEventListener(Event.COMPLETE, onSoundComplete, false, 0, true);
            		break;
            		
           		case LOADER_XML:
					loader = new URLLoader();
            		loader.load(request);
            		loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            		loader.addEventListener(Event.COMPLETE, onXMLComplete, false, 0, true);
            		break;
			}		
        }
        catch (error:Error)
        {
        	log(error.message);
        	finish();
        }
	}
	
	private function onImageComplete(event:Event):void
    {
    	data = Bitmap(Loader(loader).content).bitmapData;
    	finish();
    }
    
    private function onXMLComplete(event:Event):void
    {
    	data = XML(URLLoader(loader).data);
    	finish();
    }
    
    private function onSoundComplete(event:Event):void
    {
    	data = Sound(loader);
    	finish();
    }
    
    private function onError(event:IOErrorEvent):void
    {
    	log(event.text);
    	finish();
    }
    
    private function finish():void
    {
    	loader = null;
       	callback(this);
		callback = null;
    }
	
	
	private function log(msg:String):void
	{
		trace(id + ' (' + path + '): ' + msg);
	}

	public function get bitmapData():BitmapData
	{
		return BitmapData(data);
	}
	
	public function get sound():Sound
	{
		return Sound(data);
	}
	
	public function get xml():XML
	{
		return XML(data);
	}
}
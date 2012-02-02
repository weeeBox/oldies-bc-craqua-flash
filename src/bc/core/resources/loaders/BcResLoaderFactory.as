package bc.core.resources.loaders
{
	import bc.core.resources.BcResLoaderListener;
	import bc.core.debug.BcDebug;
	/**
	 * @author weee
	 */
	public class BcResLoaderFactory
	{
		protected static const TYPE_IMAGE_PNG : String = ".png";
		protected static const TYPE_IMAGE_JPG : String = ".jpg";
		protected static const TYPE_SOUND_WAV : String = ".wav";
		protected static const TYPE_SOUND_MP3 : String = ".mp3";
		protected static const TYPE_XML : String = ".xml";
	
		public static const LOADER_IMAGE : int = 1;
		public static const LOADER_SOUND : int = 2;
		public static const LOADER_XML : int = 3;
		
		private static var instance : BcResLoaderFactory;
		
		public function BcResLoaderFactory()
		{
			BcDebug.assert(instance == null, "Multiple res loader factory initialization");
			instance = this;
		}

		public static function getInstance() : BcResLoaderFactory
		{
			return instance;		
		}
		
		public function createLoader(id : String, path : String, listener : BcResLoaderListener) : BcResLoader
		{			
			BcDebug.assert(false, "This should be overriden in platform-specific subclass");		
			return null;
		}

		protected function extractType(path : String) : String
		{
			var dotIndex : int = path.lastIndexOf(".");
			return dotIndex == -1 ? "" : path.substring(dotIndex);
		}
	}
}

package bc.core.resources.loaders
{
	import bc.core.resources.BcResLoaderListener;
	/**
	 * @author weee
	 */
	public class BcFlashResLoaderFactory extends BcResLoaderFactory
	{
		public override function createLoader(id : String, path : String, listener : BcResLoaderListener) : BcResLoader
		{
			var type : String = extractType(path);
			
			if (type == TYPE_IMAGE_PNG || type == TYPE_IMAGE_JPG)
				return new BcBitmapLoader(id, path, listener);
			if (type == TYPE_SOUND_WAV || type == TYPE_SOUND_MP3)			
				return new BcSoundLoader(id, path, listener);
			if (type == TYPE_XML)
				return new BcXmlLoader(id, path, listener);
				
			return null;
		}
	}
}

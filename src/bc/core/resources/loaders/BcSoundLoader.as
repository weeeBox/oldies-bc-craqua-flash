package bc.core.resources.loaders
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import bc.core.resources.BcResLoaderListener;
	/**
	 * @author weee
	 */
	public class BcSoundLoader extends BcResLoader
	{
		private var sound : Sound;
		
		public function BcSoundLoader(id : String, path : String, listener : BcResLoaderListener)
		{
			super(BcResLoaderFactory.LOADER_SOUND, id, path, listener);
		}
		
		override public function load() : void
		{
			var request : URLRequest = new URLRequest(path);

			try
			{			
				sound = new Sound();
				sound.load(request);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
				sound.addEventListener(Event.COMPLETE, onSoundComplete, false, 0, true);
			}
			catch (error : Error)
			{
				sound = null;
				doFail();
			}
		}
		
		private function onSoundComplete(event : Event) : void
		{
			doFinish(sound);
			sound = null;
		}
		
		private function onError(event : IOErrorEvent) : void
		{
			sound = null;
			doFail();	
		}
	}
}

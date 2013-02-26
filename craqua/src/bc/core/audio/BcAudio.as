package bc.core.audio 
{

	/**
	 * @author Elias Ku
	 */
	public class BcAudio 
	{
		private static var impl:BcAudioImpl;
		
		public static function initialize():void
		{
			if(!BcAudioImpl.instance)
			{
				BcAudioImpl.instance = new BcAudioImpl();
				impl = BcAudioImpl.instance;
			}
		}
		
		public static function configurate(xmlName:String):void
		{
			impl.configurate(xmlName);
		}
		
		public static function centreListener(width:Number, height:Number):void
		{
			impl.setPosition(width * 0.5, height * 0.5);
		}
		
		public static function setSFXVolume(volume:Number):void
		{
			impl.soundVolume = volume;
		}
		
		public static function getSFXVolume():Number
		{
			return impl.soundVolume;
		}
	}
}
package bc.core.audio 
{
	import bc.core.display.BcApplication;
	import bc.core.device.BcAsset;
	import bc.core.device.BcDevice;

	import flash.media.SoundTransform;

	/**
	 * @author Elias Ku
	 */
	internal class BcAudioImpl 
	{
		public static var instance:BcAudioImpl;
		
		public var x:Number;
		public var y:Number;
		
		public var fading:Number = -0.002;
		public var panorama:Number = 1/320;
		
		public var soundVolume:Number = 1;
		public var musicVolume:Number = 1;
		
		private var volumeThreshold:Number = 0.01;
		
		private var soundTransform:SoundTransform = new SoundTransform();
		
		public function BcAudioImpl()
		{
			x = BcApplication.width * 0.5;
			y = BcApplication.height * 0.5;
		}
		
		public function configurate(xmlName:String):void
		{
			var xml:XML = BcAsset.getXML(xmlName);
			
			if(xml)
			{
				if(xml.hasOwnProperty("@fading")) fading = - Number(xml.@fading);
				if(xml.hasOwnProperty("@panorama")) panorama = 1 / Number(xml.@panorama);
			}
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setLevel(sound:Number = 1, music:Number = 1):void
		{
			soundVolume = sound;
			musicVolume = music;
		}	
		
		public function playSound():SoundTransform
		{
			var transform:SoundTransform;
			
			if(soundVolume > volumeThreshold)
			{
				transform = soundTransform;
				transform.pan = 0;
				transform.volume = soundVolume;
			}
			
			return transform;
		}
		
		public function playPanoramaSound(x:Number, y:Number):SoundTransform
		{
			var transform:SoundTransform;
			var dx:Number = x - this.x;
			var dy:Number = y - this.y;
			var distance:Number = Math.sqrt(dx*dx+dy*dy);
			var volume:Number = soundVolume * Math.exp(fading*distance);
			
			if(volume > volumeThreshold)
			{
				dx *= panorama;
				if ( dx > 1 )
				{
					dx = 1;
				}
				else if ( dx < -1 )
				{
					dx = -1;
				}
				
				transform = soundTransform;
				transform.pan = dx;
				transform.volume = volume;
			}
			
			return transform;
		}
		
	}
}

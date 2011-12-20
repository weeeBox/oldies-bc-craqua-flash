package bc.core.audio 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.device.BcAsset;

	import flash.media.Sound;
	import flash.media.SoundTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcSound implements BcIObjectData
	{
		private static var PLAYBACK_NORMAL:uint = 0;
		private static var PLAYBACK_RANDOM:uint = 1;
		
		private var sounds:Vector.<Sound> = new Vector.<Sound>();
		private var counter:uint;
		private var playback:uint = PLAYBACK_NORMAL;
		private var volume:Number = 1;
		
		public function BcSound()
		{
		}
		
		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@playback"))
			{
				switch ( xml.@playback.toString() )
				{
					case "normal":
						break;
					case "random":
						playback = PLAYBACK_RANDOM;
						break;
				}	
			}
			
			if(xml.hasOwnProperty("@volume"))
			{
				volume = xml.@volume;
			}
			
			for each (var node:XML in xml.sample)
			{
				sounds.push(BcAsset.getSound(node.@data));
			}
			
			if(sounds.length == 0)
			{
				if(xml.hasOwnProperty("@data"))
				{
					sounds.push(BcAsset.getSound(xml.@data));
				}
				else
				{
					sounds.push(BcAsset.getSound(xml.@id));
				}
			}
		}
		
		public function play():void
		{
			var transform:SoundTransform = BcAudioImpl.instance.playSound();
			
			if(transform)
			{
				transform.volume *= volume;
				sounds[counter].play(22.7, 0, transform);
				nextSound();
			}
		}
		
		public function playObject(x:Number, y:Number):void
		{
			var transform:SoundTransform = BcAudioImpl.instance.playPanoramaSound(x, y);
			
			if(transform)
			{
				transform.volume *= volume;
				sounds[counter].play(22.7, 0, transform);
				nextSound();
			}
		}
		
		private function nextSound():void
		{
			if(sounds.length > 1)
			{
				if(playback)
				{
					counter = uint( Math.random() * sounds.length );
				}
				else
				{
					++counter;
					if(counter==sounds.length) counter = 0;
				}
			}
		}
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("sound", BcSound, data);
		}
		
		public static function getData(id:String):BcSound
		{
			return BcSound(data[id]);
		}
	}
}

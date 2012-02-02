package bc.core.audio 
{
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.device.BcAsset;
	import bc.core.util.BcStringUtil;

	import flash.media.Sound;

	/**
	 * @author Elias Ku
	 */
	public class BcMusic implements BcIObjectData 
	{
		private var sound:Sound;
		private var loop:Boolean;
		public var musicCallback:BcMusicCallback;
		
		private var channel:SoundChannel;
		private var transform:SoundTransform = new SoundTransform();
		
		private var volumeBegin:Number = 0;
		private var volumeEnd:Number = 0;
		private var volumeSpeed:Number = 1;
		private var volumeProgress:Number = 1;
		
		public function BcMusic()
		{
		}
		
		public function parse(xml:XML):void
		{
			var id:String = xml.@id;
			
			if(xml.hasOwnProperty("@data"))
			{
				sound = BcAsset.getSound(xml.@data);
			}
			else
			{
				sound = BcAsset.getSound(id);
			}
			
			if(xml.hasOwnProperty("@loop"))
			{
				loop = BcStringUtil.parseBoolean(xml.@loop);
			}
			
			playlist.push(this);
		}
		
		public function play(time:Number = 0):void
		{
			var vol:Number;
			
			volumeBegin = 0;
			volumeEnd = 1;
				
			if(time > 0)
			{
				vol = 0;
				volumeProgress = 0;
				volumeSpeed = 1/time;
			}
			else
			{
				vol = 1;
				volumeProgress = 1;
			}
			
			transform.volume = vol * musicVolume;
			
			if(loop)
			{
				if(channel)
				{
					channel.soundTransform = transform;
				}
				else
				{
					channel = sound.play(0, 99999, transform);
				}
			}
			else
			{
				channel = sound.play(0, 0, transform);
			}
		}
		
		public function stop(time:Number = 0):void
		{
			var vol:Number;
			
			volumeBegin = volumeBegin + (volumeEnd - volumeBegin)*volumeProgress;
			volumeEnd = 0;
				
			if(time > 0)
			{
				vol = volumeBegin;
				volumeProgress = 0;
				volumeSpeed = 1/time;
			}
			else
			{
				vol = 0;
				volumeProgress = 1;
			}

			if(channel)
			{
				transform.volume = vol * musicVolume;
				channel.soundTransform = transform;
				if( vol <= 0 )
				{
					channel.stop();
					channel = null;
				}
			}
		}
		
		private function updateVolumeProgress(dt:Number):void
		{
			if(volumeProgress < 1)
			{
				volumeProgress += dt * volumeSpeed;
				if(volumeProgress > 1)
				{
					volumeProgress = 1;
				}
	
				updateVolume();
			}
		}
		
		private function updateVolume():void
		{
			var vol:Number = volumeBegin + (volumeEnd - volumeBegin)*volumeProgress;
				
			if(channel)
			{
				transform.volume = vol * musicVolume;
				channel.soundTransform = transform;
				if(vol <=0 )
				{
					channel.stop();
					channel = null;
				}
			}
		}
		
		private static var playlist:Vector.<BcMusic> = new Vector.<BcMusic>();
		private static var musicVolume:Number = 1;
		
		public static function update(dt:Number):void
		{
			for each (var track:BcMusic in playlist)
			{
				track.updateVolumeProgress(dt);
			}
		}
		
		public static function setVolume(volume:Number):void
		{
			musicVolume = volume;
			
			for each (var track:BcMusic in playlist)
			{
				track.updateVolume();
			}
		}
		
		public static function getVolume():Number
		{
			return musicVolume;
		}
		
		public static function stopAll(time:Number):void
		{
			for each (var track:BcMusic in playlist)
			{
				track.stop(time);
			}
		}
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("music", new BcMusicDataCreator(), data);
		}
		
		public static function getMusic(id:String):BcMusic
		{
			return BcMusic(data[id]);
		}
	}
}

package bc.core.motion 
{
	import flash.utils.Dictionary;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.util.BcStringUtil;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcMotionData implements BcIObjectData 
	{
		public var duration:Number = 0;
		public var count:uint = 1;
		public var playback:uint = BcPlayback.NORMAL;
		public var autoplay:Boolean;
		
		public var keys:Vector.<BcMotionKey>;
		public var weights:Vector.<BcMotionWeight>;
		
		public function BcMotionData(keys:Vector.<BcMotionKey> = null, count:uint = 1, playback:uint = 0, duration:Number = 0)
		{
			this.count = count;
			this.playback = playback;
			this.duration = duration;
			this.keys = keys;
			
			if(keys && duration==0)
			{
				duration = calcDuration();
			}			
		}

		public function parse(xml:XML):void
		{
			var key:BcMotionKey;
			var weight:BcMotionWeight;
			
			keys = new Vector.<BcMotionKey>();
			for each (var keyNode:XML in xml.key)
			{
				key = new BcMotionKey();
				key.parse(keyNode);
				keys.push(key);
			}
			
			weights = new Vector.<BcMotionWeight>();
			for each (var node:XML in xml.weight)
			{
				weight = new BcMotionWeight();
				weight.parse(node);
				weights.push(weight);
			}
			
			if(xml.hasOwnProperty("@playback"))
			{
				playback = BcPlayback.parseString(xml.@playback);
			}
			
			if(xml.hasOwnProperty("@count"))
			{
				count = xml.@count;
			}
			
			if(xml.hasOwnProperty("@duration"))
			{
				duration = xml.@duration;
			}
			else
			{
				duration = calcDuration();
			}
			
			if(xml.hasOwnProperty("@autoplay"))
			{
				autoplay = BcStringUtil.parseBoolean(xml.@autoplay);
			}
		}
		
		public function animate(time:Number, displayObject:DisplayObject):void
		{
			var weight:Number = 1;
			var i:uint;
			var beginWeight:BcMotionWeight;
			var endWeight:BcMotionWeight;
			
			if(weights.length > 0)
			{
				if(weights.length > 1)
				{
					i = weights.length;
					while(i > 1)
					{
						beginWeight = weights[i-2];
						endWeight = weights[i-1];
						if(endWeight.time >= time && beginWeight.time <= time)
						{
							break;
						}
						--i;
					}
					weight = calcWeight(beginWeight, endWeight, time);
				}
				else
				{
					weight = weights[0].value;
				}
			}
			
			if(weight > 0)
			{
				for each (var key:BcMotionKey in keys)
				{
					key.animate(time, displayObject, weight);
				}
			}
		}
		
		private function calcDuration():Number
		{
			var duration:Number = 0;
			
			for each (var key:BcMotionKey in keys)
			{
				if(key.timeEnd > duration)
				{
					duration = key.timeEnd;
				}
			}
			
			return duration;
		}
		
		private function calcWeight(begin:BcMotionWeight, end:BcMotionWeight, time:Number):Number
		{
			const bw:Number = begin.value;
			const ew:Number = end.value;
			const bt:Number = begin.time; 
			const et:Number = end.time;
			
			return bw + (ew - bw)*(time - bt)/(et - bt);
		}
		
		
		
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("motion", new BcMotionDataCreator(), data);
		}
		
		public static function getData(id:String):BcMotionData
		{
			return BcMotionData(data[id]);
		}
	}
}


package bc.core.motion 
{
	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcMotion 
	{
		public var data:BcMotionData;
		
		public var playback:uint;
		public var repeats:uint;
		public var endless:Boolean;
		
		public var time:Number = 0;
		
		public var motionCallback:BcMotionCallback;
		
		private var forward:Boolean;
		
		private var playing:Boolean;
		
		private var target:DisplayObject;
		
		public function BcMotion(target:DisplayObject = null, data:BcMotionData = null)
		{
			if(target)
			{
				setTarget(target);
			}
			
			if(data)
			{
				setData(data);
			}
		}
		
		public function setTarget(target:DisplayObject):void
		{
			this.target = target;
		}

		public function setData(data:BcMotionData):void
		{
			this.data = data;
			if(data && data.autoplay)
			{
				play();
			}
		}
		
		public function play():void
		{
			if(data)
			{
				playback = data.playback;
				repeats = data.count;
				endless = !data.count;
				if(repeats > 0)
				{
					--repeats;
				}
				
				time = 0;
				forward = true;
				
				if(playback == BcPlayback.REVERSE)
				{
					time = data.duration;
					forward = false;
				}
				
				playing = true;
			}
		}
		
		public function stop():void
		{
			playing = false;
		}

		public function update(dt:Number):void
		{
			if(playing && data)
			{
				if(forward)
				{
					time += dt;
					if(time >= data.duration)
					{
						switch(playback)
						{
							case BcPlayback.NORMAL:
								if(endCycle())
								{
									time = 0;
								}
								break;
								
							case BcPlayback.PINGPONG:
								time = data.duration;
								forward = false;								
								break;
						}
					}
				}
				else
				{
					time -= dt;
					if(time <= 0 && endCycle())
					{
						switch(playback)
						{
							case BcPlayback.REVERSE:
								time = data.duration;
								break;
								
							case BcPlayback.PINGPONG:
								time = 0;
								forward = true;
								break;
						}
					}
				}
				
				data.animate(time, target);
			}
		}
		
		public function manual(time:Number):void
		{
			if(data)
			{
				data.animate(time, target);
			}
		}
		
		private function endCycle():Boolean
		{
			playing = (endless || repeats > 0);
			
			if(!endless && repeats > 0)
			{
				--repeats;
			}
			
			return playing;
		}		
	}
}

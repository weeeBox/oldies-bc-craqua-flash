package bc.core.motion 
{
	import bc.core.util.BcStringUtil;
	import bc.core.display.BcModel;
	import bc.core.math.Vector2;
	import bc.core.motion.tweens.BcITween;
	import bc.core.motion.tweens.BcTweenFactory;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcMotionKey 
	{		
		public var timeBegin:Number = 0;
		public var timeEnd:Number = 0;
		public var duration:Number = 0;
		public var ease:Function = BcEasing.linear;
		public var flags:uint;
		public var node:String;
		public var tween:BcITween;
		
		public function BcMotionKey()
		{
		}
		
		public function parse(xml:XML):void
		{
			tween = BcTweenFactory.createFromXML(xml);
			
			// TODO: парсить флаги, closeEnd, closeBegin
			
			if(xml.hasOwnProperty("@ease"))
			{
				ease = BcEasing.getFunction(xml.@ease);
			}
			
			if(xml.hasOwnProperty("@time"))
			{
				BcStringUtil.parseVector2(xml.@time, VECTOR);
				timeBegin = VECTOR.x;
				timeEnd = VECTOR.y;
				duration = timeEnd - timeBegin;
			}
			
			if(xml.hasOwnProperty("@duration"))
			{
				duration = xml.@duration;
			}
			
			if(xml.hasOwnProperty("@node"))
			{
				node = xml.@node.toString();
			}
		}
		
		public function animate(t:Number, displayObject:DisplayObject, weight:Number):void
		{
			var target:DisplayObject = displayObject;
			var updating:Boolean = true;
			var progress:Number = (t - timeBegin) / duration;
			
			if( t < timeBegin )
			{
				if(flags & BcMotionKeyFlag.CLOSED_BEGIN)
				{
					progress = 0;
				}
				else
				{
					updating = false;
				}
			}
			else if( t > timeEnd )
			{
				if(flags & BcMotionKeyFlag.CLOSED_END)
				{
					progress = 1;
				}
				else
				{
					updating = false;
				}
			}
			
			if(updating)
			{
				if(node && target is BcModel)
				{
					target = BcModel(displayObject).lookup[node];
				}
				
				if(target)
				{
					tween.apply(ease(progress), target, weight);
				}
			}
		}
		
		private static var VECTOR:Vector2 = new Vector2();
	}
}

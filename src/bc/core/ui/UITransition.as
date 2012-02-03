package bc.core.ui 
{
	import bc.core.motion.easing.BcEaseFunction;
	import bc.core.util.BcColorTransformUtil;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class UITransition 
	{
		public static const FLAG_RESET:uint = 0x1;
		public static const FLAG_SHOW:uint = 0x2;
		public static const FLAG_HIDE:uint = 0x4;
		public static const FLAG_ENABLE:uint = 0x8;
		public static const FLAG_DISABLE:uint = 0x10;
		public static const FLAG_ACTIVATE:uint = 0x20;
		public static const FLAG_DEACTIVATE:uint = 0x40;
		
		public static const FLAGS_OPEN_BEGIN:uint = FLAG_RESET | FLAG_SHOW | FLAG_ACTIVATE | FLAG_DISABLE;
		public static const FLAGS_OPEN_END:uint = FLAG_ENABLE;
		public static const FLAGS_CLOSE_BEGIN:uint = FLAG_DISABLE;
		public static const FLAGS_CLOSE_END:uint = FLAG_DEACTIVATE | FLAG_HIDE;
		
		public static const OPEN:Vector.<uint> = Vector.<uint>([FLAGS_OPEN_BEGIN, FLAGS_OPEN_END]);
		public static const CLOSE:Vector.<uint> = Vector.<uint>([FLAGS_CLOSE_BEGIN, FLAGS_CLOSE_END]);
		
		public var flags:Vector.<uint>;
		public var x:Vector.<Number>;
		public var y:Vector.<Number>;
		public var sx:Vector.<Number>;
		public var sy:Vector.<Number>;
		public var a:Vector.<Number>;
		public var color:Vector.<ColorTransform>;
		
		public var ease:BcEaseFunction;
		
		
		public function UITransition(x : Vector.<Number>, y : Vector.<Number>, sx : Vector.<Number>, sy : Vector.<Number>, a : Vector.<Number>, colorVector : Vector.<uint>, flags : Vector.<uint>, ease : BcEaseFunction)
		{
			this.x = x;
			this.y = y;
			this.sx = sx;
			this.sy = sy;
			this.a = a;
			this.flags = flags;
			this.ease = ease;
			
			if (colorVector != null)
			{
				color = Vector.<ColorTransform>([				
					BcColorTransformUtil.setColorARGB(new ColorTransform(), colorVector[0], colorVector[1]),
					BcColorTransformUtil.setColorARGB(new ColorTransform(), colorVector[2], colorVector[3])
					]);
			}
		}
	}
}


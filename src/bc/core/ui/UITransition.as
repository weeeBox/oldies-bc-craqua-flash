package bc.core.ui 
{
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
		
		public static const OPEN:Array = [FLAGS_OPEN_BEGIN, FLAGS_OPEN_END];
		public static const CLOSE:Array = [FLAGS_CLOSE_BEGIN, FLAGS_CLOSE_END];
		
		public var flags:Vector.<uint>;
		public var x:Vector.<Number>;
		public var y:Vector.<Number>;
		public var sx:Vector.<Number>;
		public var sy:Vector.<Number>;
		public var a:Vector.<Number>;
		public var color:Vector.<ColorTransform>;
		
		public var ease:Function;
		
		
		public function UITransition(properties:Object)
		{
			if(properties.hasOwnProperty("x"))
			{
				x = Vector.<Number>(properties.x);
			}
			
			if(properties.hasOwnProperty("y"))
			{
				y = Vector.<Number>(properties.y);
			}
			
			if(properties.hasOwnProperty("sx"))
			{
				sx = Vector.<Number>(properties.sx);
			}
			
			if(properties.hasOwnProperty("sy"))
			{
				sy = Vector.<Number>(properties.sy);
			}
			
			if(properties.hasOwnProperty("a"))
			{
				a = Vector.<Number>(properties.a);
			}
			
			if(properties.hasOwnProperty("color"))
			{
				var colors : Vector.<uint> = Vector.<uint>(properties.color);
				
				color = Vector.<ColorTransform>([				
					BcColorTransformUtil.setColorARGB(new ColorTransform(), colors[0], colors[1]),
					BcColorTransformUtil.setColorARGB(new ColorTransform(), colors[2], colors[3])
					]);
			}
			
			if(properties.hasOwnProperty("flags"))
			{
				flags = Vector.<uint>(properties.flags);
			}
			
			if(properties.hasOwnProperty("ease"))
			{
				ease = properties.ease;
			}
		}
	}
}


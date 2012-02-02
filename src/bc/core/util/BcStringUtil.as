package bc.core.util 
{
	import bc.core.math.BcFloatInterval;
	import bc.core.math.Vector2;

	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcStringUtil 
	{
		
		public static function parseMask(string:String):uint
		{
			var mask:uint = 0;
			var array:Array = string.split(" ");
			
			for each (var substring:String in array)
			{
				mask |= ( 1 << uint( parseInt(substring) ) );
			}
			
			return mask;
		}
		
		public static function parseVector2(string:String, out:Vector2 = null):Vector2
		{
			var args:Array = string.split("; ");
			
			var x:Number = 0;
			var y:Number = 0;
			
			if(args.length > 0)
			{
				x = y = parseNumber(args[0]);
				
				if(args.length > 1)
				{
					y = parseNumber(args[1]);
				}
			}
			
			if(!out)
			{
				out = new Vector2();
			}
			
			out.x = x;
			out.y = y;
			
			return out;
		}
		
		public static function parseColorTransform(string:String, out:ColorTransform = null):ColorTransform
		{
			var args:Array = string.split("; ");
			var arg:String;
			
			var mult:uint = 0xffffffff;
			var add:uint;
			
			const k:Number = 1/255;
			
			if(args.length > 0)
			{
				if(args.length > 1)
				{
					add = uint( parseInt(args[1]) );
				}
				
				arg = args[0];
				mult = uint( parseInt(arg) );
				
				if(arg.length < 9)
				{
					mult |= 0xff000000;
				}
			}
			
			if(!out)
			{
				out = new ColorTransform();
			}
			
			out.alphaMultiplier = k * ( 0xff & ( mult >> 24 ) );
			out.redMultiplier   = k * ( 0xff & ( mult >> 16 ) );
			out.greenMultiplier = k * ( 0xff & ( mult >> 8 ) );
			out.blueMultiplier  = k * ( 0xff & ( mult ) );
			
			out.alphaOffset     = 0xff & ( add >> 24 );
			out.redOffset       = 0xff & ( add >> 16 );
			out.greenOffset     = 0xff & ( add >> 8 );
			out.blueOffset      = 0xff & ( add );

			return out;
		}
		
		public static function parseFloatInterval(string:String, out:BcFloatInterval = null):BcFloatInterval
		{
			var args:Array = string.split("; ");
			
			var min:Number = 0;
			var max:Number = 0;
			
			if(args.length > 0)
			{
				min = max = parseNumber(args[0]);
				
				if(args.length > 1)
				{
					max = parseNumber(args[1]);
				}
			}
			
			if(!out)
			{
				out = new BcFloatInterval();
			}
			
			out.setInterval(min, max);
			
			return out;
		}
		
		public static function parseBoolean(string:String):Boolean
		{
			return (string=="true");
		}
		
		public static function parseNumber(string:String):Number
		{
			return parseFloat(string);
		}

		public static function parseInteger(string:String) : uint
		{
			return parseInt(string);
		}
		
		public static function parseUInteger(string:String) : uint
		{
			return uint(parseInt(string));
		}
	}
}

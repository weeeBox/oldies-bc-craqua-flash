package bc.core.util 
{
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcColorTransformUtil 
	{
		
		public static function lerpMult(ct:ColorTransform, begin:ColorTransform, end:ColorTransform, t:Number):ColorTransform
		{
			const inv:Number = 1-t;
			
			ct.alphaMultiplier = inv * begin.alphaMultiplier + t * end.alphaMultiplier;
			ct.redMultiplier = inv * begin.redMultiplier + t * end.redMultiplier;
			ct.greenMultiplier = inv * begin.greenMultiplier + t * end.greenMultiplier;
			ct.blueMultiplier = inv * begin.blueMultiplier + t * end.blueMultiplier;
			
			return ct;
		}
		
		public static function lerpColor(ct:ColorTransform, begin:ColorTransform, end:ColorTransform, t:Number):ColorTransform
		{
			const inv:Number = 1-t;
			
			ct.alphaMultiplier = inv * begin.alphaMultiplier + t * end.alphaMultiplier;
			ct.redMultiplier = inv * begin.redMultiplier + t * end.redMultiplier;
			ct.greenMultiplier = inv * begin.greenMultiplier + t * end.greenMultiplier;
			ct.blueMultiplier = inv * begin.blueMultiplier + t * end.blueMultiplier;
			
			ct.alphaOffset = inv * begin.alphaOffset + t * end.alphaOffset;
			ct.redOffset = inv * begin.redOffset + t * end.redOffset;
			ct.greenOffset = inv * begin.greenOffset + t * end.greenOffset;
			ct.blueOffset = inv * begin.blueOffset + t * end.blueOffset;
			
			return ct;
		}
		
		public static function setMultipliersARGB(out:ColorTransform, argb:uint):ColorTransform
		{
			const m:Number = 1/255;
			
			out.alphaMultiplier = ( ( argb >> 24 ) & 0xFF ) * m;
			out.redMultiplier = ( ( argb >> 16 ) & 0xFF ) * m;
			out.greenMultiplier = ( ( argb >> 8) & 0xFF ) * m;
			out.blueMultiplier = ( argb & 0xFF ) * m;
			
			/*out.alphaOffset = ((add_argb >> 24) & 0xFF);
			out.redOffset = ((add_xrgb >> 16) & 0xFF);
			out.greenOffset = ((add_xrgb >> 8) & 0xFF);
			out.blueOffset = (add_xrgb & 0xFF);*/
			
			return out;
		}
		
		public static function setColorARGB(out:ColorTransform, multARGB:uint = 0xffffffff, offsetARGB:uint = 0x0):ColorTransform
		{
			const m:Number = 1/255;
			
			out.alphaMultiplier = ( ( multARGB >> 24 ) & 0xFF ) * m;
			out.redMultiplier = ( ( multARGB >> 16 ) & 0xFF ) * m;
			out.greenMultiplier = ( ( multARGB >> 8) & 0xFF ) * m;
			out.blueMultiplier = ( multARGB & 0xFF ) * m;
			
			out.alphaOffset = ((offsetARGB >> 24) & 0xFF);
			out.redOffset = ((offsetARGB >> 16) & 0xFF);
			out.greenOffset = ((offsetARGB >> 8) & 0xFF);
			out.blueOffset = (offsetARGB & 0xFF);
			
			return out;
		}
		
		public static function reset(out:ColorTransform):ColorTransform
		{
			out.alphaMultiplier = 
			out.redMultiplier = 
			out.greenMultiplier = 
			out.blueMultiplier = 1;
			
			out.alphaOffset = 
			out.redOffset = 
			out.greenOffset = 
			out.blueOffset = 0;
			
			return out;
		}
	}
}

package bc.ui
{
	import bc.core.motion.easing.BcEaseFunction;

	/**
	 * @author weee
	 */
	public class BcEaseClose extends BcEaseFunction
	{
		override public function easing(t : Number) : Number
		{
			return t * t * t;
		}
	}
}

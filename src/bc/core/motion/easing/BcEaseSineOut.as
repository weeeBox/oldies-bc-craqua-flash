package bc.core.motion.easing
{
	import bc.core.motion.easing.BcEaseFunction;

	/**
	 * @author weee
	 */
	public class BcEaseSineOut extends BcEaseFunction
	{
		override public function easing(t : Number) : Number
		{
			return Math.sin(t * (Math.PI * 0.5));
		}
	}
}

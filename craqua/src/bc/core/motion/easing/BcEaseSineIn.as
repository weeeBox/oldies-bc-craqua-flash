package bc.core.motion.easing
{
	/**
	 * @author weee
	 */
	public class BcEaseSineIn extends BcEaseFunction
	{
		override public function easing(t : Number) : Number
		{
			return -Math.cos(t * (Math.PI * 0.5)) + 1;
		}
	}
}

package bc.core.motion.easing
{

	/**
	 * @author weee
	 */
	public class BcEaseSineInOut extends BcEaseFunction
	{
		override public function easing(t : Number) : Number
		{
			return (-0.5)*(Math.cos(Math.PI*t) - 1);
		}
	}
}

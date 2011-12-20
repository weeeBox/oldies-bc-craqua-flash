package bc.core.math 
{

	/**
	 * @author Elias Ku
	 */
	public class BcFloatInterval 
	{
		private var value:Number = 0;
		private var spread:Number = 0;
		private var random:Boolean;
		
		public function BcFloatInterval(value:Number = 0, spread:Number = 0)
		{
			this.value = value;
			this.spread = spread;
			random = ( Math.abs(spread) > 0 );
		}

		public function setInterval(min:Number, max:Number):void
		{
			value = min;
			spread = max - value;
			random = ( Math.abs(spread) > 0 );
		}
		
		public function setValue(value:Number):void
		{
			this.value = value;
			spread = 0;
			random = false;
		}
		
		public function getValue():Number
		{
			var val:Number = value;
			
			if(random)
			{
				val += Math.random() * spread;
			}
			
			return val;
		}
		
		public function isZero():Boolean
		{
			return (value==0 && spread==0);
		}
	}
}

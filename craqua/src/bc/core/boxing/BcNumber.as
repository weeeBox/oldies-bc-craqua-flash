package bc.core.boxing
{
	/**
	 * @author weee
	 */
	public class BcNumber
	{
		public var value : Number;
		
		public function BcNumber(value : Number) 
		{
			this.value = value;
		}
		
		public function intValue() : int
		{
			return int(value);
		}
		
		public function uintValue() : uint
		{
			return uint(value);
		}
	}
}

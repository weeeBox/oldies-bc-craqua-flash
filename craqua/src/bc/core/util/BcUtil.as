package bc.core.util
{
	import flash.utils.Dictionary;
	/**
	 * @author weee
	 */
	public class BcUtil
	{
		public static function createDictionary(data : Array) : Dictionary
		{
			var dictionary : Dictionary = new Dictionary();
			
			var length : int = data.length;
			for (var i : int = 0; i < length; i += 2)
			{
				var key : String = String(data[i]);
				dictionary[key] = data[i + 1];	
			}
			
			return dictionary;
		}
	}
}

package bc.core.data 
{
	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	internal class BcDataTypeInfo
	{
		public var dataCreator:BcObjectDataCreator;
		public var collection:Dictionary;
		
		public function BcDataTypeInfo(dataCreator:BcObjectDataCreator, collection:Dictionary)
		{
			this.dataCreator = dataCreator;
			this.collection = collection;
		}
	}

}

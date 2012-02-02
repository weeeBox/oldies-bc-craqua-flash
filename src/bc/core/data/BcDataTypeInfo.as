package bc.core.data 
{

	/**
	 * @author Elias Ku
	 */
	internal class BcDataTypeInfo
	{
		public var dataCreator:BcObjectDataCreator;
		public var collection:Object;
		
		public function BcDataTypeInfo(dataCreator:BcObjectDataCreator, collection:Object)
		{
			this.dataCreator = dataCreator;
			this.collection = collection;
		}
	}

}

package bc.core.data 
{

	/**
	 * @author Elias Ku
	 */
	internal class BcDataTypeInfo
	{
		public var dataClass:Class;
		public var collection:Object;
		
		public function BcDataTypeInfo(dataClass:Class, collection:Object)
		{
			this.dataClass = dataClass;
			this.collection = collection;
		}
	}

}

package bc.core.display
{
	import bc.core.data.BcIObjectData;
	import bc.core.data.BcObjectDataCreator;

	public class BcSheetDataCreator extends BcObjectDataCreator
	{
		override public function create() : BcIObjectData
		{
			return	 new BcSheetData();
		}
	}
}

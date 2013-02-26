package bc.world.item
{
	import bc.core.data.BcIObjectData;
	import bc.core.data.BcObjectDataCreator;

	public class BcItemDataCreator extends BcObjectDataCreator
	{
		override public function create() : BcIObjectData
		{
			return	 new BcItemData();
		}
	}
}

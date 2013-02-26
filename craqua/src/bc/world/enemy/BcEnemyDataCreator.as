package bc.world.enemy
{
	import bc.core.data.BcIObjectData;
	import bc.core.data.BcObjectDataCreator;

	public class BcEnemyDataCreator extends BcObjectDataCreator
	{
		override public function create() : BcIObjectData
		{
			return	 new BcEnemyData();
		}
	}
}

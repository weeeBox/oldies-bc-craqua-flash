package bc.world.bullet
{
	import bc.core.data.BcIObjectData;
	import bc.core.data.BcObjectDataCreator;

	public class BcExplosionDataCreator extends BcObjectDataCreator
	{
		override public function create() : BcIObjectData
		{
			return	 new BcExplosion();
		}
	}
}

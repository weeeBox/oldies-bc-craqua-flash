package bc.core.audio
{
	import bc.core.data.BcIObjectData;
	import bc.core.data.BcObjectDataCreator;

	public class BcSoundDataCreator extends BcObjectDataCreator
	{
		override public function create() : BcIObjectData
		{
			return	 new BcSound();
		}
	}
}

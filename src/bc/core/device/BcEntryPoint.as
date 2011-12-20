package bc.core.device 
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Elias Ku
	 */
	public class BcEntryPoint extends MovieClip 
	{
		public function BcEntryPoint()
		{
			super();
			stop();
		}
		
		public function get loadingProgress():Number
		{
			const loaded:uint = root.loaderInfo.bytesLoaded;
        	const total:uint = root.loaderInfo.bytesTotal;
        	
        	return loaded / total;
		}
		
		public function get loadingCompleted():Boolean
		{
			const loaded:uint = root.loaderInfo.bytesLoaded;
        	const total:uint = root.loaderInfo.bytesTotal;
        	
			return loaded == total;
		}

		public function nextEntryPoint(entryPointClassName:String):void
        {
        	if(parent)
			{
				parent.removeChild(this);
			}
			
        	// Переходим на слудующий фрейм, перед тем как создавать загруженое приложение..
			nextFrame();
            
        	// Рефлексия
            var entryCls:Class = Class(getDefinitionByName(entryPointClassName));

            // Передаём управление следующему приложению...
            new entryCls();
        }
	}
}

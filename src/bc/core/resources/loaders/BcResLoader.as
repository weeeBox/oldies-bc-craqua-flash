package bc.core.resources.loaders
{
	import bc.core.debug.BcDebug;
	import bc.core.resources.BcResLoaderListener;
	
	/**
	 * @author weee
	 */
	public class BcResLoader
	{
		private var type : int = -1;
		
		protected var id : String;
		protected var path : String;
		protected var listener : BcResLoaderListener;
	
		public function BcResLoader(type : int, id : String, path : String, listener : BcResLoaderListener) : void
		{
			this.type = type;
			
			this.id = id;
			this.path = path;
			this.listener = listener;	
		}
		
		public function load() : void
		{
		}
		
		public function getType() : int
		{
			return type;
		}
		
		public function getId() : String
		{
			return id;
		}

		protected function doFinish(data : Object) : void
		{
			BcDebug.assert(data != null, path);
			
			listener.resLoadingComplete(this, data);
			listener = null;
			path = null;
		}
		
		protected function doFail() : void
		{
			listener.resLoadingFailed(this);
			listener = null;
			path = null;
		}
	}
}

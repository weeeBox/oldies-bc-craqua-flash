package bc.core.resources
{
	import bc.core.resources.loaders.BcResLoader;
	/**
	 * @author weee
	 */
	public interface BcResLoaderListener
	{
		function resLoadingComplete(loader : BcResLoader, data : Object) : void;
		function resLoadingFailed(loader : BcResLoader) : void;
	}
}

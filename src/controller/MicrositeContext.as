package controller
{
	import flash.display.DisplayObjectContainer;
	
	import org.assetloader.AssetLoader;
	import org.robotlegs.mvcs.SignalContext;
	
	public class MicrositeContext extends SignalContext {
		public function MicrositeContext(loader:AssetLoader, contextView:DisplayObjectContainer=null, autoStartup:Boolean=true) {
			super(contextView, autoStartup);
		}
	}
}
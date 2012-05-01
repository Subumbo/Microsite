package {
	import controller.MicrositeContext;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.assetloader.AssetLoader;
	
	public class Main extends Sprite {
		
		
		private var _context:MicrositeContext;
		private var _loader:AssetLoader;
		
		public function Main() {
			//init();
			graphics.beginFill(0xFF0000, .4);
			graphics.drawRoundRect(0,0,600,660,40,40);
		}
		
		public function init(loader:AssetLoader=null):void {
			if(!loader) {
				// running without preloader --> assets need loading
			}else {
				// running with Preloader
				_loader = loader;
				if(!stage) addEventListener(Event.ADDED_TO_STAGE, startup);
				else startup();
			}
		}
		
		private function startup(e:Event=null):void {
			if(e) removeEventListener(Event.ADDED_TO_STAGE, startup);
			_context = new MicrositeContext(_loader, stage)	
		}
	}
}
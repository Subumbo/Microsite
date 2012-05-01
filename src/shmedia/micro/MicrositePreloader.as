package shmedia.micro {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	
	public class MicrositePreloader extends Sprite {
		
		protected var _loader:AssetLoader;
		protected var _config:XML;
		
		public function MicrositePreloader(configURL:String) {
			_loader = new AssetLoader();
			_loader.add('config', new URLRequest('config.xml'), AssetType.XML);
			_loader.onChildComplete.addOnce(configLoaded);
			_loader.start();
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		protected function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
			
		/**
		 * Callback for loader when config data is ready.
		 * Loads copt and asset xml files.
		 */		
		protected function configLoaded(signal:LoaderSignal, child:ILoader):void {
			var config:XML = _config = XML(child.data);
			var locale:String = config.item.(@key == 'locale');
			var root:String = config.item.(@key == 'root');
			if(root != "") root += "/";
			
			_loader.add('copy', new URLRequest(root + 'resources/xml/' + locale + '_copy.xml'), AssetType.XML);
			_loader.add('assets', new URLRequest(root + 'resources/xml/' + locale + '_assets.xml'), AssetType.XML);
			
			_loader.onError.addOnce(onErrorXML);
			_loader.onComplete.addOnce(dataLoaded);
			
			_loader.start();
		}
		
		
		protected function onErrorXML(signal:ErrorSignal):void {
			trace("XML LOAD ERROR: " + signal.message)
		}
		
		/**
		 * Callback when xml data is loaded
		 * Feeds loader with config data from assets xml 
		 * @param signal
		 * @param data
		 * 
		 */		
		protected function dataLoaded(signal:LoaderSignal, data:Dictionary):void {
			var assetsXML:XML = XML(data['assets']);
			var list:XMLList = assetsXML.required.asset;
			var asset:XML;
			for each(asset in list) {
				_loader.add(asset.@id, new URLRequest(asset.@src));
			}
			
			list = assetsXML.lazy.asset;
			for each(asset in list) {
				_loader.addLazy(asset.@id, asset.@src);
			}
			
			_loader.onError.addOnce(onErrorAsset);
			_loader.onComplete.addOnce(assetsLoaded);
			
			_loader.start()
		}
		
		/**
		 * Callback when all required data and assets are loaded.  
		 * The main app is now ready and can be added to stage and initialised.
		 */		
		protected function assetsLoaded(signal:LoaderSignal, data:Dictionary):void {
			var main:Object = _loader.getLoader('main').data;
			main.init(_loader);
			stage.addChild(main as DisplayObject);
		}
			
		protected function onErrorAsset(error:ErrorSignal):void {
			trace('ASSET LOAD ERROR: ' + error.message)			
		}
	}
}
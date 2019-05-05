package  {
	
	import flash.display.MovieClip;
	import flash.net.FileReference;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	import images.JPGEncoder;
	import images.PNGEncoder;
	import flash.display.SimpleButton;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.text.TextFieldAutoSize;
	
	
	public class TestAndroid extends MovieClip {
		
		private var _txt:TextField;
		
		public function TestAndroid() {
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)e.target.removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			_txt=this.getChildByName("txt") as TextField;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			//
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void{
			var targetName:String=e.target.name;
			
			var file:File=File.applicationStorageDirectory;//C:\Users\Administrator\AppData\Roaming\TestAndroid\Local Store
			file=file.resolvePath("testAndroid/aa.png");//C:\Users\Administrator\AppData\Roaming\TestAndroid\Local Store\testAndroid\aa.png
			
			if(targetName=="saveBtn"){
				log("save:"+file.nativePath);
				var bmd:BitmapData=new BitmapData(100,100,true,0xFFFF0000);
				writeImage(file,bmd);
			}else if(targetName=="showBtn"){
				log("load:"+file.url);
				var loader:Loader=new Loader();
				var context:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain,null);
				loader.load(new URLRequest(file.url),context);//不能是file.nativePath
				configureListeners(loader.contentLoaderInfo);
			}
		}
		
		/**将bitmapData保存为本地图片*/
		private function writeImage(file:File,bmd:BitmapData,isPng:Boolean=true,quality:Number=100):void{
			var stream:FileStream=new FileStream();
			stream.open(file,FileMode.WRITE);
			var bytes:ByteArray;
			if(isPng) bytes = PNGEncoder.encode(bmd);
			else      bytes = (new JPGEncoder(quality)).encode(bmd);
			stream.writeBytes(bytes);
			stream.close();
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void {
            log("completeHandler: " + event);
			var loaderInfo:LoaderInfo=event.target as LoaderInfo;
			addChild(loaderInfo.content);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            log("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            log("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            log("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            log("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            log("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            log("unLoadHandler: " + event);
        }

		
		private function log(str:String):void{
			trace(str);
			_txt.appendText(str+"\n");
		}
	}
	
}

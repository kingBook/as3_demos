package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
	
	
	public class Test extends MovieClip {
		
		
		public function Test() {
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)e.target.removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			var bg:MovieClip=this.getChildByName("bg") as MovieClip;
			var jpgBtn:SimpleButton=this.getChildByName("jpgBtn") as SimpleButton;
			var pngBtn:SimpleButton=this.getChildByName("pngBtn") as SimpleButton;
			var writePngBtn:SimpleButton=this.getChildByName("writePngBtn") as SimpleButton;
			var writeJpgBtn:SimpleButton=this.getChildByName("writeJpgBtn") as SimpleButton;
			//
			jpgBtn.addEventListener("click",onClick);
			pngBtn.addEventListener("click",onClick);
			writePngBtn.addEventListener("click",onClick);
			writeJpgBtn.addEventListener("click",onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			var bmd:BitmapData;
			if(e.target.name=="jpgBtn"){
				bmd=new BitmapData(bg.width,bg.height);
				bmd.draw(bg);
				saveJpg(bmd,"book00.jpg");
			}else if(e.target.name=="pngBtn"){
				bmd=new BitmapData(bg.width,bg.height,true,0x000000);//注意bitmapData.transparent必须设置为true,图片才透明
				bmd.draw(bg);
				savePng(bmd,"book01.png");
			}else if(e.target.name=="writeJpgBtn"){
				bmd=new BitmapData(bg.width,bg.height);
				bmd.draw(bg);
				
				var file:File=new File(File.desktopDirectory.nativePath+"/book10.jpg");
				writeImage(file,bmd,false,80);
			}else if(e.target.name=="writePngBtn"){
				bmd=new BitmapData(bg.width,bg.height,true,0x000000);//注意bitmapData.transparent必须设置为true,图片才透明
				bmd.draw(bg);
				
				file=new File(File.desktopDirectory.nativePath+"/book11.png");
				writeImage(file,bmd,true);
			}
		}
		
		private function saveJpg(bmd:BitmapData,fileName:String):void{
			var fileRef:FileReference=new FileReference();
			var encoder:JPGEncoder=new JPGEncoder(80);
			var bytes:ByteArray=encoder.encode(bmd);
			fileRef.save(bytes, fileName);//保存到磁盘，会出现个系统保存对话框。
			bytes.clear();
			
		}
		
		private function savePng(bmd:BitmapData,fileName:String):void{
			var fileRef:FileReference=new FileReference();
			var bytes:ByteArray=PNGEncoder.encode(bmd);
			fileRef.save(bytes, fileName);//保存到磁盘，会出现个系统保存对话框。
			bytes.clear();
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
		
	};
	
}
			
			
			
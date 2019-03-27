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
			//
			jpgBtn.addEventListener("click",onClick);
			pngBtn.addEventListener("click",onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			var bmd:BitmapData=new BitmapData(bg.width,bg.height);
			bmd.draw(bg);
			if(e.target.name=="jpgBtn"){
				saveJpg(bmd,"book.jpg");
			}else if(e.target.name=="pngBtn"){
				savePng(bmd,"book1.png");
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
		
	}
	
}
			
			
			
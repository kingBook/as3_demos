package  {
	
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.GestureEvent;
	
	
	public class Main extends MovieClip {
		
		private var _printStr:String="";
		private var _printTxt:TextField;
		
		public function Main() {
			
			createPrintTextField();
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
			
			
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch); 
			//stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouch); 
			stage.addEventListener(TouchEvent.TOUCH_END, onTouch); 
		}
		
		private function onTouch(e:TouchEvent){ 
			print("touchType:"+e.type,"id:"+e.touchPointID,e.stageX,e.stageY); 
		} 
		
		private function createPrintTextField():void{
			_printTxt=new TextField();
			_printTxt.autoSize=TextFieldAutoSize.LEFT;
			_printTxt.background=true;
			_printTxt.x=70;
			_printTxt.y=5;
			addChild(_printTxt);
		}
		
		public function print(...rest):void{
			if(_printStr)_printStr+="\n";
			for(var i:int=0;i<rest.length;i++){
				_printStr+=rest[i]+(i<rest.length-1?" ":"");
			}
			_printTxt.text=_printStr;
			_printTxt.parent.addChild(_printTxt);
			trace(rest);
		}
	}
	
}

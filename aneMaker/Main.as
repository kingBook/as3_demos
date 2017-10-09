package  {
	
	import flash.display.MovieClip;
	
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	
	public class Main extends MovieClip {
		
		private var _txt:TextField;
		private var _iapAne:IapAne;
		
		private function log(...params):void{
			var str:String="";
			for(var i:int=0;i<params.length;i++){
				str+=params[i].toString()+" ";
			}
			_txt.appendText(str+"\n");
			trace(str);
		}
		
		public function Main() {
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)removeEventListener(Event.ADDED_TO_STAGE,init);
			_txt=this.getChildByName("txt") as TextField;
			//
			_iapAne=new IapAne();
			_iapAne.logFun=log;
			_iapAne.addEventListener(StatusEvent.STATUS,onStatus);
			
			_iapAne.initialize();
		
			log("Main::init();");
		}
		
		private function onStatus(e:StatusEvent):void{
			var str:String="code:"+e.code+","+"level:"+e.level;	
			log(str);
		}
	}
	
}

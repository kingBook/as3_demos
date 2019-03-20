package{
	
	import flash.events.Event;
	import flash.display.MovieClip;

	public class Main extends MovieClip{
		
		
		public function Main(){
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)removeEventListener(Event.ADDED_TO_STAGE,init);
			
			UIManager.getInstance().init(this);
			
			UIManager.getInstance().print("english",1,2,3);
			UIManager.getInstance().print("chinese",1,2,3);
		}
		
	};
}




















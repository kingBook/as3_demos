package{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Ball extends MovieClip{
		public const radius:Number=20;
		public var vx:Number=0;
		public var vy:Number=0;
		public function Ball(){
			super();
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)e.target.removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		private function update(e:Event):void{
			this.x+=vx;
			this.y+=vy;
		}
		
	};
}
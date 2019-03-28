package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Box extends MovieClip {
		
		private var _pt1:MovieClip;
		private var _pt2:MovieClip;
		
		public function Box() {
			super();
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)e.target.removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			_pt1=this.getChildByName("pt1") as MovieClip;
			_pt2=this.getChildByName("pt2") as MovieClip;
		}
		
		public function get pos1():Point{
			var rect:Rectangle=_pt1.getRect(this.parent);
			return new Point(rect.x+rect.width/2,rect.y+rect.height/2);
		}
		
		public function get pos2():Point{
			var rect:Rectangle=_pt2.getRect(this.parent);
			return new Point(rect.x+rect.width/2,rect.y+rect.height/2);
		}
	}
	
}

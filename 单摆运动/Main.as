package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Main extends MovieClip {
		
		private var _g:Number;
		private var _currentW:Number;//瞬时角速度
		private var _l:Number;//摆线长度
		private var _startAngle:Number;//初始角度
		private var _currentAngle:Number;//当前角度
		private var _delta:Number;
		private var _ptm:Number;
		
		private var _o:Point;
		private var _ball:MovieClip;
		
		public function Main() {
			_g=30;
			_currentW=0;
			_l=1;
			_startAngle=_currentAngle=-90*0.01745;
			_delta=1/60;
			_ptm=100;
			
			_o=new Point();
			_o.x=stage.stageWidth*0.5;
			_o.y=stage.stageHeight*0.5;
			
			_ball=new Ball();
			_ball.x=_o.x+Math.sin(_currentAngle)*_l*_ptm;
			_ball.y=_o.y+Math.cos(_currentAngle)*_l*_ptm;
			this.addChild(_ball);
			
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		private function update(e:Event):void{
			
			var k1:Number,k2:Number,k3:Number,k4:Number;
			var l1:Number,l2:Number,l3:Number,l4:Number;
			{
				k1=_currentW;
				l1=-(_g/_l)*Math.sin(_currentAngle);
				
				k2=_currentW+_delta*l1/2;
				l2=-(_g/_l)*Math.sin(_currentAngle+_delta*k1/2);
				
				k3=_currentW+_delta*l2/2;
				l3=-(_g/_l)*Math.sin(_currentAngle+_delta*k2/2);
				
				k4=_currentW+_delta*l3;
				l4=-(_g/_l)*Math.sin(_currentAngle*_delta*k3);
				
				_currentAngle+=_delta*(k1+2*k2+2*k3+k4)/(2*Math.PI);
				
				_currentW+=_delta*(l1+2*l2+2*l3+l4)/(2*Math.PI);
				
			}
			//
			_ball.x=_o.x+Math.sin(_currentAngle)*_l*_ptm;
			_ball.y=_o.y+Math.cos(_currentAngle)*_l*_ptm;
			//
			
			//
			
			trace("_currentAngle:"+(_currentAngle*57.3).toFixed(1),
				  "getW():"+getW().toFixed(1),
				  "getT():"+getT().toFixed(1));
		}
		
		/**瞬时角速度*/
		private function getW():Number{
			var w:Number=Math.sqrt(2/_l*_l)*
						 Math.sqrt(_g*_l* (Math.cos(_currentAngle)-Math.cos(_startAngle)) );
			return w;
		}
		
		/**返回单摆周期*/
		private function getT():Number{
			var t:Number=(2*Math.PI*Math.sqrt(_l/_g))/
						 (1-0.062*_startAngle*_startAngle);
			return t;
		}
	}
	
}

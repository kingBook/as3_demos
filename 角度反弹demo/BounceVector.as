package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class BounceVector extends MovieClip {
		private var _ball:Ball;
		private var _boxList:Vector.<Box>;
		public function Main() {
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
			
		}
		
		private function init(e:Event=null):void{
			if(e)e.target.removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			addEventListener(Event.ENTER_FRAME,update);
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
			//
			_boxList=new Vector.<Box>();
			for(var i:int=0;i<this.numChildren;i++){
				var box:Box=this.getChildAt(i) as Box;
				if(box)_boxList.push(box);
			}
			//
			_ball=new Ball();
			_ball.x=stage.stageWidth/2;
			_ball.y=stage.stageHeight/2;
			this.addChild(_ball);
			
			
		}
		
		private function clickHandler(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			//
			const angle:Number=Math.atan2(this.mouseY-_ball.y,this.mouseX-_ball.x);
			//
			const speedLen:Number=20;
			_ball.vx=Math.cos(angle)*speedLen;
			_ball.vy=Math.sin(angle)*speedLen;
			
		}
		
		private function update(e:Event):void{
			for(var i:int=0;i<_boxList.length;i++){
				var box:Box=_boxList[i];
				var collideResult:*=getCollideResult(_ball,box);
				if(collideResult){
					bounceBallV(_ball, collideResult.pt1,collideResult.pt2);
				}
			}
			
		}
		
		/**根据碰撞线段计算球的反弹向量*/
		private function bounceBallV(ball:Ball,pt1:Point,pt2:Point):void{
			var angle:Number=Math.atan2(pt2.y-pt1.y, pt2.x-pt1.x);
			var cos:Number=Math.cos(angle);
			var sin:Number=Math.sin(angle);
			//以pt1为坐标原点,计算出ball中心的相对位置
			var x1:Number=ball.x-pt1.x;
			var y1:Number=ball.y-pt1.y;
			//旋转坐标
			var x2:Number=cos*x1+sin*y1;
			var y2:Number=cos*y1-sin*x1;
			//旋转球的移动速度向量
			var vx1:Number=cos*ball.vx+sin*ball.vy;
			var vy1:Number=cos*ball.vy-sin*ball.vx;
			//实现反弹
			//if(y2>-ball.radius){
				y2=-ball.radius;
				vy1*=-1;//反弹系数
				
				//将一切旋转回去
				x1=cos*x2-sin*y2;
				y1=cos*y2+sin*x2;
				//
				ball.vx=cos*vx1-sin*vy1;
				ball.vy=cos*vy1+sin*vx1;
				//
				ball.x=pt1.x+x1;
				ball.y=pt1.y+y1;
			//}
		}
		
		/**如果发生碰撞则返回 {pt1:Point,pt2:Point}，没发生碰撞则返回null*/
		private function getCollideResult(ball:Ball,box:Box):*{
			if(Math.abs(ball.vx+ball.vy)<=0)return null;
			var ballVAngle:Number=Math.atan2(ball.vy,ball.vx);//球移动速度向量的方向
			var ballVLen:Number=Math.sqrt(ball.vx*ball.vx+ball.vy*ball.vy);//球移动速度向量的长度
			var ballCenter:Point=new Point(ball.x,ball.y);//球中心
			//球移动速度方向上的另一点
			var ballNextPt:Point=new Point(ballCenter.x+Math.cos(ballVAngle)*(ball.radius+ballVLen),
										   ballCenter.y+Math.sin(ballVAngle)*(ball.radius+ballVLen));
			var inset:*=getSegmentsIntersect(ballCenter,ballNextPt, box.pos1,box.pos2);
			if(inset){
				return {pt1:box.pos1,pt2:box.pos2};
			}
			return null;
		}
		
		/**线段ab与线段cd的交点,有交点返回交点，没有交点返回null*/
		private function getSegmentsIntersect(a:*,b:*,c:*,d:*):*{
			// 三角形abc 面积的2倍  
			var area_abc:Number = (a.x - c.x) * (b.y - c.y) - (a.y - c.y) * (b.x - c.x);  
		  
			// 三角形abd 面积的2倍  
			var area_abd:Number = (a.x - d.x) * (b.y - d.y) - (a.y - d.y) * (b.x - d.x);   
		  
			// 面积符号相同则两点在线段同侧,不相交 (对点在线段上的情况,本例当作不相交处理);  
			if (area_abc*area_abd>=0) {  
				return null;  
			}  
		  
			// 三角形cda 面积的2倍  
			var area_cda:Number = (c.x - a.x) * (d.y - a.y) - (c.y - a.y) * (d.x - a.x);  
			// 三角形cdb 面积的2倍  
			// 注意: 这里有一个小优化.不需要再用公式计算面积,而是通过已知的三个面积加减得出.  
			var area_cdb:Number = area_cda + area_abc - area_abd ;  
			if (  area_cda * area_cdb >= 0 ) {  
				return null;  
			}  
			//计算交点坐标  
			var t:Number = area_cda / ( area_abd- area_abc );
			var dx:Number= t*(b.x - a.x);
			var dy:Number= t*(b.y - a.y);
			return {x:a.x + dx, y:a.y + dy};
		}
		
		
	
	}
	
}

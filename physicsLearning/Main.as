package  {
	import flash.geom.Point;
	import flash.display.Sprite;
	
	public class Main extends Sprite{

		public function Main() {
			var g:Point=getGravityForce(2);
			trace(getSupportingForce(1,new Point(2,10),1));
		}
		
		
		/**
		 * 计算物体的重力
		 * @param	m 物体的质量(kg)
		 * @param	g 重力加速度(m/s^2)
		 * @return 物体受到的重力(kg.m/s^2, N)
		 */
		private function getGravityForce(m:Number,g:Point=null):Point{
			if(g==null){
				g=new Point(0,9.8);
			}
			//G=mg
			var G:Point=new Point();
			G.x=m*g.x;
			G.y=m*g.y;
			return G;
		}
		
		/**
		 * 计算物体的支持力
		 * @param	m物体的质量(kg)
		 * @param	g 重力加速度(m/s^2)
		 * @param	k 斜率(平面的斜度，y与x的比)
		 * @return (N)
		 */
		private function getSupportingForce(m:Number,g:Point=null,k:Number=0):Point{
			var G:Point=getGravityForce(m,g);
			var rad:Number=Math.atan(k);//倾斜的弧度
			var resut:Point=new Point();
			resut.x=-G.x*Math.sin(rad);
			resut.y=-G.y*Math.cos(rad);
			return resut;
			
		}

	}
	
}

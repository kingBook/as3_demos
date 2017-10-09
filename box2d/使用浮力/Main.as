package{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import Box2D.Dynamics.Joints.b2PulleyJoint;
	import Box2D.Dynamics.Joints.b2PulleyJointDef;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;

	/**
	* 
	*/
	public class Main extends BaseMain{
		
		private var _bodies:Vector.<b2Body>=new Vector.<b2Body>();
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			createBodies();
			createBuoyancyController();
		}
		
		private function createBodies():void{
			for(var i:int=0;i<50;i++){
				var x:Number=stage.stageWidth*0.5;
				var y:Number=50;
				var body:b2Body=Math.random()>0.5?createBox(20,20,x,y):createCircle(10,x,y);
				_bodies.push(body);
			}
		}
		
		private function createBuoyancyController():void{
			var controller:b2BuoyancyController=new b2BuoyancyController();
			controller.angularDrag=0.5;
			controller.density=1.5;//设置水的密度,要大于水中刚体的密度才能上浮
			//controller.gravity=null;
			controller.linearDrag=0.5;
			controller.normal.Set(0,-1);//设置水面的法向量
			controller.offset=-200/_pixelToMeter;//水面的高度，默认在最顶部（y轴0的位置）,-100表示向下移动100
			//controller.useDensity=false;
			//controller.useWorldGravity=true;
			//controller.velocity.Set(0,0);
			_world.AddController(controller);
			for(var i:int=0;i<_bodies.length;i++){
				controller.AddBody(_bodies[i]);
			}
			
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















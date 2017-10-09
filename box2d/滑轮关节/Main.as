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

	/**
	* 
	*/
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var bodyA:b2Body=this.createBox(50,50,100,400);
			var bodyB:b2Body=this.createCircle(25,700,400);
			
			var jointDef:b2PulleyJointDef=new b2PulleyJointDef();
			
			//悬挂的两个点
			var gaA:b2Vec2=new b2Vec2(100/_pixelToMeter,100/_pixelToMeter);
			var gaB:b2Vec2=new b2Vec2(700/_pixelToMeter,100/_pixelToMeter);
			
			var anchorA:b2Vec2=bodyA.GetWorldCenter();
			var anchorB:b2Vec2=bodyB.GetWorldCenter();
			var r:Number=1;//如果系数是2,那么 length1 的变化会是 length2 的两倍。另外连接 body1 的绳子的约束力将会是连接 body2 绳子的一半。
			jointDef.Initialize(bodyA,bodyB,gaA,gaB,anchorA,anchorB,r);
			var joint:b2PulleyJoint=_world.CreateJoint(jointDef) as b2PulleyJoint;
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















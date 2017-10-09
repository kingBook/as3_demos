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
			var bodyA:b2Body=this.createBox(50,50,400,350);
			var bodyB:b2Body=_world.GetGroundBody();
			
			var jointDef:b2PulleyJointDef=new b2PulleyJointDef();
			
			//悬挂点
			var bindPos:b2Vec2=new b2Vec2(400/_pixelToMeter,300/_pixelToMeter);
			
			var anchorA:b2Vec2=bodyA.GetWorldCenter();
			var anchorB:b2Vec2=bodyB.GetWorldCenter();
			
			//距离必须大于滑轮关节的最小距离
			trace(b2Vec2.Distance(anchorA,bindPos));
			if(b2Vec2.Distance(anchorA,bindPos)>b2PulleyJoint.b2_minPulleyLength){
				var r:Number=0;
				jointDef.Initialize(bodyA,bodyB,bindPos,bindPos,anchorA,anchorB,r);
				var joint:b2PulleyJoint=_world.CreateJoint(jointDef) as b2PulleyJoint;
			}
			
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















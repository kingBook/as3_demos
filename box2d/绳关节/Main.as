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
	import Box2D.Dynamics.Joints.b2RopeJointDef;
	import Box2D.Dynamics.Joints.b2RopeJoint;
	
	//出现脱节时，调velocityIterations, positionIterations
	//_world.Step(1/30,128,128);
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		private const ropeW:Number=20;
		private const ropeH:Number=20;
		
		override protected function init():void{
			var bodies:Vector.<b2Body>=new Vector.<b2Body>();
			var i:int;
			for(i=0;i<10;i++){
				var body:b2Body=createBox(ropeW,ropeH,400+i*ropeW,100);
				bodies[i]=body;
				if(i>0){
					var bodyA:b2Body=bodies[i-1];
					var bodyB:b2Body=bodies[i];
					var halfW:Number=ropeW*0.5/_ptm_ratio;
					var anchorA:b2Vec2=new b2Vec2(bodyA.GetPosition().x+halfW,bodyA.GetPosition().y);
					var anchorB:b2Vec2=new b2Vec2(bodyB.GetPosition().x-halfW,bodyB.GetPosition().y);
					var maxLength:Number=0.1;
					createRopeJoint(bodyA,bodyB,anchorA,anchorB,maxLength);
				}
			}
			bodies[0].SetType(b2Body.b2_staticBody);
			
			var bigBox:b2Body=createBox(400,400,400+i*ropeW,100);
			bigBox.SetSensor(true);
			createRopeJoint(bodies[bodies.length-1],bigBox,
							new b2Vec2(bodies[bodies.length-1].GetPosition().x+halfW,bodies[bodies.length-1].GetPosition().y),//anchorA
							new b2Vec2(bigBox.GetPosition().x-200/_ptm_ratio,bigBox.GetPosition().y),//anchorB
							0.1);//maxLength
		}
		
		private function createRopeJoint(bodyA:b2Body,bodyB:b2Body,anchorA:b2Vec2,anchorB:b2Vec2,maxLength:Number):void{
			var jointDef:b2RopeJointDef=new b2RopeJointDef();
			jointDef.Initialize(bodyA,bodyB,anchorA,anchorB,maxLength);
			jointDef.length=5;
			b2RopeJoint(_world.CreateJoint(jointDef));
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















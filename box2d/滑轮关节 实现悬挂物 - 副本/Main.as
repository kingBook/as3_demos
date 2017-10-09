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
		
		private var _body:b2Body;
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			_body=this.createBox(50,50,400,100);
			
			
		}
		
		override protected function stepBefore():void{
			
		}
		
		override protected function stepAfter():void{
			//trace("pos1:",_body.GetPosition(),"\n");
			
			var dt:Number=1/_pixelToMeter;
			var grav:b2Vec2=_world.GetGravity();
			var vel:b2Vec2=_body.GetLinearVelocity();
			var pos:b2Vec2=_body.GetPosition();
			trace("pos0:",pos);
			
			
			var stepV:b2Vec2=new b2Vec2(vel.x*dt+grav.x*dt*dt,vel.y*dt+grav.y*dt*dt);
			trace("stepV:",stepV);
			
			var nextPos:b2Vec2=new b2Vec2();
			nextPos.SetV(pos);
			nextPos.Add(stepV);
			trace("nextPos:",nextPos, "\n");
		}
		
		
	};
}




















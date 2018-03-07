package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2LineJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;

	/**
	* 
	*/
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var bodyA:b2Body=this.createBox(50,50,400,300);
			var bodyB:b2Body=this.createCircle(25,400,300);
			bodyA.SetType(b2Body.b2_staticBody);
			
			var jointDef:b2LineJointDef=new b2LineJointDef();
			var anchor:b2Vec2=bodyA.GetWorldCenter();
			var axis:b2Vec2=new b2Vec2(1,0);
			jointDef.Initialize(bodyA,bodyB,anchor,axis);
			_world.CreateJoint(jointDef);
			
		}
		
		
	};
}




















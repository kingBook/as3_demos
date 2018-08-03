package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var bodyA:b2Body=this.createBox(50,50,400,300);
			var bodyB:b2Body=this.createCircle(25,500,300);
			
			var jointDef:b2WeldJointDef=new b2WeldJointDef();
			var anchor:b2Vec2=bodyA.GetWorldCenter();
			jointDef.Initialize(bodyA,bodyB,anchor);
			
			_world.CreateJoint(jointDef);
			
		}
		
	};
}
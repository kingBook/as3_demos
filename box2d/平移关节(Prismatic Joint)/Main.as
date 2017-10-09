﻿package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;

	/**
	* 
	*/
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var bodyA:b2Body=this.createBox(50,50,300,400);
			var bodyB:b2Body=this.createCircle(25,500,400);
			
			
			var jointDef:b2PrismaticJointDef=new b2PrismaticJointDef();
			
			var anchor:b2Vec2=bodyA.GetWorldCenter();
			var axis:b2Vec2=new b2Vec2(1,1);
			jointDef.Initialize(bodyB,bodyA,anchor,axis);
			_world.CreateJoint(jointDef);
			
			bodyA.SetFixedRotation(true);
		}
		
		
	};
}




















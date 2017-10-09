package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;

	/**
	* 旋转关节，指定刚体只能绕着某一个锚点旋转
	*/
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var bodyA:b2Body=this.createBox(50,50,400,300);
			var bodyB:b2Body=this.createCircle(25,500,300);
			bodyA.SetType(b2Body.b2_staticBody);
			
			var jointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
			var anchor:b2Vec2=bodyA.GetWorldCenter();
			jointDef.Initialize(bodyA,bodyB,anchor);
			
			//限制在一个弧度范围内可以转动
			//jointDef.enableLimit=true;
			//jointDef.lowerAngle=45*0.01745;
			//jointDef.upperAngle=135*0.01745;

			//马达速度
			//jointDef.motorSpeed=4;
			//jointDef.maxMotorTorque=400;//必须赋值,否则他的默认值为:0
			//jointDef.enableMotor=true;
			
			_world.CreateJoint(jointDef);
			
		}
		
	};
}
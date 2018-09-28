package{
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.*;
	import flash.events.KeyboardEvent;

	/**
	* 
	*/
	public class Main extends BaseMain{
		private var worldScale:int=30;
		// variables which will be used to determine key pressed
		private var left:Boolean=false;
		private var right:Boolean=false;
		private var up:Boolean=false;
		private var down:Boolean=false;
		// the body of the cart
		private var cart:b2Body;
		// wheels motor speed
		private var motorSpeed:Number=0;
		// front and rear wheels revolute joints
		private var rearWheelRevoluteJoint:b2RevoluteJoint;
		private var frontWheelRevoluteJoint:b2RevoluteJoint;
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			// ************************ THE FLOOR ************************ //
			var vertices:Array=[
				new b2Vec2(0,300/worldScale),
				new b2Vec2(400/worldScale,0),
				new b2Vec2(400/worldScale,300/worldScale)
			];
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsArray(vertices,vertices.length);
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density=0;
			floorFixture.friction=10;
			floorFixture.restitution=0;
			floorFixture.shape=floorShape;
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(400/worldScale,300/worldScale);
			var floor:b2Body=_world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			
			// add the cart
			var carBodyDef:b2BodyDef = new b2BodyDef();
			carBodyDef.type=b2Body.b2_dynamicBody;
			carBodyDef.position.Set(320/worldScale,50/worldScale);
			carBodyDef.userData=new Object();
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox(30/worldScale,10/worldScale);
			var boxDef:b2FixtureDef = new b2FixtureDef();
			boxDef.density=0.5;
			boxDef.friction=3;
			boxDef.restitution=0.3;
			boxDef.filter.groupIndex=-1;
			boxDef.shape=box;
			cart=_world.CreateBody(carBodyDef);
			cart.CreateFixture(boxDef);
			// wheel shape
			var wheelShape:b2CircleShape=new b2CircleShape(12/worldScale);
			// wheel fixture
			var wheelFixture:b2FixtureDef = new b2FixtureDef();
			wheelFixture.density=1;
			wheelFixture.friction=3;
			wheelFixture.restitution=0.1;
			wheelFixture.filter.groupIndex=-1;
			wheelFixture.shape=wheelShape;
			// wheel body definition
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type=b2Body.b2_dynamicBody;
			// real wheel
			wheelBodyDef.position.Set(cart.GetWorldCenter().x-(16/worldScale),cart.GetWorldCenter().y+(15/worldScale));
			var rearWheel:b2Body=_world.CreateBody(wheelBodyDef);
			rearWheel.CreateFixture(wheelFixture);
			// front wheel
			wheelBodyDef.position.Set(cart.GetWorldCenter().x+(16/worldScale),cart.GetWorldCenter().y+(15/worldScale));
			var frontWheel:b2Body=_world.CreateBody(wheelBodyDef);
			frontWheel.CreateFixture(wheelFixture);
			// rear joint
			var rearWheelRevoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
			rearWheelRevoluteJointDef.Initialize(rearWheel,cart,rearWheel.GetWorldCenter());
			rearWheelRevoluteJointDef.enableMotor=true;
			rearWheelRevoluteJointDef.maxMotorTorque=10000;
			rearWheelRevoluteJoint=_world.CreateJoint(rearWheelRevoluteJointDef) as b2RevoluteJoint;
			// front joint
			var frontWheelRevoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
			frontWheelRevoluteJointDef.Initialize(frontWheel,cart,frontWheel.GetWorldCenter());
			frontWheelRevoluteJointDef.enableMotor=true;
			frontWheelRevoluteJointDef.maxMotorTorque=10000;
			frontWheelRevoluteJoint=_world.CreateJoint(frontWheelRevoluteJointDef) as b2RevoluteJoint;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyReleased);
		}
		
		private function keyPressed(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37 :
					left=true;
					break;
				case 38 :
					up=true;
					break;
				case 39 :
					right=true;
					break;
				case 40 :
					down=true;
					break;
			}
		}
		private function keyReleased(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37 :
					left=false;
					break;
				case 38 :
					up=false;
					break;
				case 39 :
					right=false;
					break;
				case 40 :
					down=false;
					break;
			}
		}
		
		override protected function stepBefore():void{
			// up and down control wheels motor
			if (up) {
				motorSpeed-=0.5;
			}
			if (down) {
				motorSpeed+=0.5;
			}
			// left and right control cart torque
			if (left) {
				cart.ApplyTorque(-3);
			}
			if (right) {
				cart.ApplyTorque(3);
			}
			// motor friction
			motorSpeed*=0.99;
			// motor max speed
			if (motorSpeed>100) {
				motorSpeed=100;
			}
			// setting wheels motor speed
			rearWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			frontWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
		}
		
	};
}




















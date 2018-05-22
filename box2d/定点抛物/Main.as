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
	import flash.events.MouseEvent;

	public class Main extends BaseMain{
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			this.stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void{
			var circle:b2Body=this.createCircle(25,50,300);
			var target:b2Vec2=new b2Vec2(e.stageX/_pixelToMeter,e.stageY/_pixelToMeter);
			var velocity:b2Vec2=getVelocityForTarget(circle,target,1/30);
			circle.SetLinearVelocity(velocity);
		}
		
		/*
		//计算轨迹点
		b2Vec2 getTrajectoryPoint( b2Vec2& startingPosition, b2Vec2& startingVelocity, float n )  
		{  
			//velocity and gravity are given per second but we want time step values here  
			float t = 1 / 60.0f; // seconds per time step (at 60fps)  
			b2Vec2 stepVelocity = t * startingVelocity; // m/s  
			b2Vec2 stepGravity = t * t * m_world->GetGravity(); // m/s/s  
		  
			return startingPosition + n * stepVelocity + 0.5f * (n*n+n) * stepGravity;  
		}  */
		
		//返回需要到达抛物线上的点(target)的线性向量
		private function getVelocityForTarget(body:b2Body,target:b2Vec2,deltaTime:Number,n:int=20):b2Vec2{
			//float t = 1 / 60.0f; // seconds per time step (at 60fps)
			//b2Vec2 stepVelocity = t * startingVelocity; // m/s
			//b2Vec2 stepGravity = t * t * m_world->GetGravity(); // m/s/s
			//return startingPosition + n * stepVelocity + 0.5f * (n*n+n) * stepGravity;
			
			//stepVelocity=(target-startingPosition-0.5f * (n*n+n) * stepGravity)/n;
			//startingVelocity=stepVelocity/t;
			
			var gravity:b2Vec2=body.GetWorld().GetGravity();
			var stepGravityX:Number=deltaTime*deltaTime*gravity.x;
			var stepGravityY:Number=deltaTime*deltaTime*gravity.y;
			
			var stepVelocityX:Number=(target.x-body.GetPosition().x-0.5*(n*n+n)*stepGravityX)/n;
			var stepVelocityY:Number=(target.y-body.GetPosition().y-0.5*(n*n+n)*stepGravityY)/n;
			var startingVelocityX:Number=stepVelocityX/deltaTime;
			var startingVelocityY:Number=stepVelocityY/deltaTime;
			return new b2Vec2(startingVelocityX,startingVelocityY);
			
		}
		
	};
}




















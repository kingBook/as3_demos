package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	
	public class Main extends BaseMain{
		
		
		public function Main(){
			super(new b2Vec2(0,0));
		}
		
		
		override protected function init():void{
			UIManager.getInstance().init(this);
			
			var boxA:b2Body=createBox(30,30,50,300);
			var circle:b2Body=createCircle(15,50,400);
			var boxB:b2Body=createBox(50,200,700,300);
			boxA.SetUserData({type:"boxA"});
			circle.SetUserData({type:"circle"});
			boxB.SetUserData({type:"boxB"});
			
			boxB.SetType(b2Body.b2_staticBody);
			
			boxA.SetType(b2Body.b2_kinematicBody);
			boxA.SetLinearVelocity(new b2Vec2(10,0));
			boxA.SetPreSolveCallback(preSolve);
			boxA.SetContactBeginCallback(contactBegin);
			boxA.SetContactEndCallback(contactEnd);
			boxA.SetPostSolveCallback(postSolve);
			
			circle.SetType(b2Body.b2_dynamicBody);
			circle.SetLinearVelocity(new b2Vec2(5,0));
			circle.SetPreSolveCallback(preSolve);
			circle.SetContactBeginCallback(contactBegin);
			circle.SetContactEndCallback(contactEnd);
			circle.SetPostSolveCallback(postSolve);
		}
		
		private function contactBegin(contact:b2Contact,other:b2Body):void{
			UIManager.getInstance().print("contactBegin:"+other.GetUserData().type);
		}
		
		private function contactEnd(contact:b2Contact,other:b2Body):void{
			UIManager.getInstance().print("contactEnd:"+other.GetUserData().type);
		}
		
		private function postSolve(contact:b2Contact,impulse:b2ContactImpulse,other:b2Body):void{
			UIManager.getInstance().print("postSolve:"+other.GetUserData().type);
		}
		
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold,other:b2Body):void{
			UIManager.getInstance().print("preSolve:"+other.GetUserData().type);
			
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















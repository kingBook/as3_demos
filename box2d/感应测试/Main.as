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
			var boxA:b2Body=createBox(30,30,50,300);
			var boxB:b2Body=createBox(40,40,700,300);
			boxA.SetUserData({type:"boxA"});
			boxB.SetUserData({type:"boxB"});
			boxA.SetSensor(true);
			boxB.SetSensor(true);
			boxA.SetPreSolveCallback(preSolve);
			boxA.SetContactBeginCallback(contactBegin);
			boxA.SetContactEndCallback(contactEnd);
			boxA.SetPostSolveCallback(postSolve);
		}
		
		private function contactBegin(contact:b2Contact,other:b2Body):void{
			trace("contactBegin:"+other.GetUserData().type);
		}
		
		private function contactEnd(contact:b2Contact,other:b2Body):void{
			trace("contactEnd:"+other.GetUserData().type);
		}
		
		private function postSolve(contact:b2Contact,impulse:b2ContactImpulse,other:b2Body):void{
			trace("postSolve:"+other.GetUserData().type);
		}
		
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold,other:b2Body):void{
			trace("preSolve:"+other.GetUserData().type);
			
		}
		
		override protected function stepBefore():void{ 
			
		}
		
		
	};
}




















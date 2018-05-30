package{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Contacts.b2ContactEdge;

	/**
	* 旋转关节，指定刚体只能绕着某一个锚点旋转
	*/
	public class Main extends BaseMain{
		
		private var _box:b2Body;
		
		public function Main(){
			super(new b2Vec2(0,10));
		}
		
		override protected function init():void{
			var box:b2Body=createBox(25,25,stage.stageWidth*0.5,stage.stageHeight*0.5);
			box.SetUserData({tag:"box"});
			_box=box;
			
			var circle:b2Body=createCircle(30,stage.stageWidth*0.5,stage.stageHeight*0.5);
			circle.SetUserData({tag:"circle"});
			
			bind(box,circle);
			
			var bigBox:b2Body=createBox(40,40,stage.stageWidth*0.5,stage.stageHeight*0.5+100);
			bigBox.SetAngle(45*Math.PI/180);
			bigBox.SetUserData({tag:"bigBox"});
			bigBox.SetType(b2Body.b2_staticBody);
			bigBox.SetSensor(true);
		}
		
		private function bind(b1:b2Body,b2:b2Body):void{
			var jointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
			jointDef.Initialize(b1,b2,b1.GetPosition());
			jointDef.localAnchorA=new b2Vec2();
			jointDef.localAnchorB=new b2Vec2();
			_world.CreateJoint(jointDef);
		}
		
		override protected function stepAfter():void{
			var ce:b2ContactEdge=_box.GetContactList();
			for(ce;ce;ce=ce.next){
				if(!ce.contact.IsTouching())continue;
				var tag:String=ce.other.GetUserData().tag;
				trace(tag);
			}
		}
		
	};
}
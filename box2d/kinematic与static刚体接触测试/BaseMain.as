package{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BaseMain extends Sprite{
		protected var _gravity:b2Vec2;
		protected var _ptm_ratio:Number=30;
		protected var _world:b2World;
		protected var _debugDraw:b2DebugDraw;
		protected var _worldSprite:Sprite;
		private var _mj:b2MouseJoint;
		public function BaseMain(gravity:b2Vec2){
			_gravity=gravity;
			
			if(stage)myInit(); else addEventListener(Event.ADDED_TO_STAGE,myInit);
		}
		private function myInit(e:Event=null):void{
			if(e)removeEventListener(Event.ADDED_TO_STAGE,myInit);
			_worldSprite=new Sprite();
			this.addChild(_worldSprite);
			
			_world=new b2World(_gravity,true);
			_world.SetContactListener(new MyContactListener());
			createDebugDraw();
			createWrapWallBodies(0,0,stage.stageWidth,stage.stageHeight);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			//_facade.global.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			addEventListener(Event.ENTER_FRAME,enterFrame);
			init();
		}
		
		protected function init():void{ }
		
		private function createDebugDraw():void{
			_debugDraw=new b2DebugDraw();
			_debugDraw.SetSprite(this);
			_debugDraw.SetDrawScale(_ptm_ratio);
			_debugDraw.SetFillAlpha(0);
			_debugDraw.SetLineThickness(0.5);
			_debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(_debugDraw);
		}
		
		private function mouseHandler(e:MouseEvent):void{
			var x:Number = _worldSprite.mouseX;
			var y:Number = _worldSprite.mouseY;
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					mouseDownHandler(x,y);
					break;
				case MouseEvent.MOUSE_MOVE:
					mouseMoveHandler(x,y);
					break;
				case MouseEvent.MOUSE_UP:
					mouseUpHandler(x,y);
					break;
				default:
			}
		}
		protected function mouseDownHandler(x:Number,y:Number):void{
			var b:b2Body=getPosBody(x,y);
			startDragBody(b,x,y);
		}
		private function mouseMoveHandler(x:Number,y:Number):void{
			if(_mj)_mj.SetTarget(new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
		}
		protected function mouseUpHandler(x:Number,y:Number):void{
			stopDragBody();
		}
		private function stopDragBody():void {
			_mj && _world.DestroyJoint(_mj);
		}
		
		private function enterFrame(e:Event):void{
			stepBefore();
			_world.Step(1/30,128,128);
			stepAfter();
			_world.ClearForces();
			mouseMoveHandler(_worldSprite.mouseX,_worldSprite.mouseY);
			_world.DrawDebugData();
		}
		protected function stepBefore():void{ }
		protected function stepAfter():void{ }

		
		/** 开始拖动刚体*/
		private function startDragBody(b:b2Body, x:Number, y:Number):void {
			if (!b || b.GetType()!=b2Body.b2_dynamicBody) return;
			_mj && _world.DestroyJoint(_mj);
			var jointDef:b2MouseJointDef=new b2MouseJointDef();
				jointDef.bodyA = _world.GetGroundBody();
				jointDef.bodyB = b;
				jointDef.target.Set(x/_ptm_ratio,y/_ptm_ratio);
				jointDef.maxForce=1e6;
			_mj = _world.CreateJoint(jointDef) as b2MouseJoint;
		}
		
		protected function createBox(w:Number,h:Number,x:Number,y:Number):b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			var body:b2Body=_world.CreateBody(bodyDef);
			
			var s:b2PolygonShape = new b2PolygonShape();
			s.SetAsBox(w/_ptm_ratio*0.5,h/_ptm_ratio*0.5);
			var fixtrureDef:b2FixtureDef = new b2FixtureDef();
			fixtrureDef.shape = s;
			body.CreateFixture(fixtrureDef);
			
			body.SetType(b2Body.b2_dynamicBody);
			body.SetPosition(new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
			return body;
		}
		
		protected function createCircle(radius:Number,x:Number,y:Number):b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			var body:b2Body=_world.CreateBody(bodyDef);
			
			var s:b2CircleShape = new b2CircleShape(radius/_ptm_ratio);
			var fixtrureDef:b2FixtureDef = new b2FixtureDef();
			fixtrureDef.shape = s;
			body.CreateFixture(fixtrureDef);
			
			body.SetType(b2Body.b2_dynamicBody);
			body.SetPosition(new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
			return body;
		}
		
		private function createWrapWallBodies(x:Number, y:Number, w:Number, h:Number):void{
			var bodies:Vector.<b2Body>=getWrapWallBodies(x,y,w,h);
			var i:int=bodies.length, b:b2Body;
			while(--i>=0){
				b=bodies[i];
				b.SetType(b2Body.b2_staticBody);
			}
		}
		
		private function getWrapWallBodies(x:Number, y:Number, w:Number, h:Number):Vector.<b2Body> {
			var thickness:uint = 20;
			var bodies:Vector.<b2Body> = new Vector.<b2Body>(4,true);
			//顶
			bodies[0]=createBox(w, thickness, w * 0.5 + x,  y - thickness * 0.5);
			//底
			bodies[1]=createBox(w, thickness, w * 0.5 + x,  h + thickness * 0.5 + y);
			//左
			bodies[2]=createBox(thickness, h, x - thickness * 0.5, h * 0.5 + y);
			//右
			bodies[3]=createBox(thickness, h, x +w + thickness * 0.5, h * 0.5 + y);
			return bodies;
		}
		
		/**返回位置下的刚体*/
		private function getPosBody(x:Number,y:Number):b2Body {
			var b:b2Body;
			_world.QueryPoint(function(fixture:b2Fixture):Boolean {
				b=fixture.GetBody();
				return false;
			},new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
			return b;
		}
	};
}
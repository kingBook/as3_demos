package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	import flash.geom.Point;

	public class Main extends Sprite{
		private const maxSpeed:Number=2;
		private const maxWheelRotation:Number=45;
		
		private var _car:MovieClip;
		private var _carBody:MovieClip;
		private var _carWheels:Vector.<MovieClip>;
		
		private var _vNormalized:Point=new Point();
		private var _velocity:Point=new Point();
		private var _isDriveing:Boolean=false;
		private var _wheelRotation:Number=0;
		private var _speed:Number=0;
		private var _friction:Number=0.8;
		
		public function Main(){
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToState);
		}
		
		private function onAddedToState(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToState);
			//
			_car=this.getChildByName("car") as MovieClip;
			_carBody=_car["body"];
			_carWheels=new Vector.<MovieClip>();
			for(var i:int=0;i<4;i++){
				_carWheels.push(_car["wheel"+i]);
			}
			
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyHandler);
		}
		
		private function onKeyHandler(e:KeyboardEvent){
			if(e.type==KeyboardEvent.KEY_DOWN){
				if(e.keyCode==Keyboard.A){
					_vNormalized.x=-1;
				}else if(e.keyCode==Keyboard.D){
					_vNormalized.x=1;
				}
				if(e.keyCode==Keyboard.W){
					_vNormalized.y=1;
				}else if(e.keyCode==Keyboard.S){
					_vNormalized.y=-1;
				}
			}else{
				if(e.keyCode==Keyboard.A){
					_vNormalized.x=0;
				}else if(e.keyCode==Keyboard.D){
					_vNormalized.x=0;
				}
				if(e.keyCode==Keyboard.W){
					_vNormalized.y=0;
				}else if(e.keyCode==Keyboard.S){
					_vNormalized.y=0;
				}
			}
		}
		
		public function clamp(value:Number, min:Number, max:Number):Number{
		  if (value < min) value = min;
		  else if (value > max) value = max;
		  return value;
		}
		
		private function Drive(vNormalized:Point,moveSpeed:Number=1,wheelRotateSpeed:Number=1):void{
			_isDriveing=true;
			
			var speedDirection:Number=vNormalized.y>0?1:vNormalized.y<0?-1:0;
			_speed=clamp(_speed+speedDirection*moveSpeed,-maxSpeed,maxSpeed);
			
			var wheelAngleDirection:Number=vNormalized.x>0?1:vNormalized.x<0?-1:0;
			_wheelRotation=clamp(_wheelRotation+wheelAngleDirection*wheelRotateSpeed,-maxWheelRotation,maxWheelRotation);
		}
		
		private function StopDrive():void{
			_isDriveing=false;
		}
		
		private function onUpdate(e:Event):void{
			if(_vNormalized.length>0){
				Drive(_vNormalized);
			}else{
				StopDrive();
			}
			
			for(var i:int=0;i<2;i++){
				_carWheels[i].rotation=_wheelRotation;
			}
			
			
			//_wheelRotation轮子的方向[-45,45]
			//把车轮向量分解成两个分量：X轴方向的为推力（前进力），影响汽车的位移
			//Y轴方向的为旋转力，影响汽车的角度
			var onward:Number = _speed * Math.cos(_wheelRotation*Math.PI/180);//汽车位移，x轴方向的分力
			var yy:Number = _speed * Math.sin(_wheelRotation*Math.PI/180);//y轴方向的分力
			var myRotation:Number = Math.atan2(yy, length);//汽车要改变的角度（弧度值）
			trace("_wheelRotation:"+_wheelRotation,"myRotation:",myRotation*180/Math.PI);
			_car.rotation+= myRotation*0.05 * 180 / Math.PI;//汽车转向
			//汽车位移
			_velocity.x = onward * Math.cos(_car.rotation*Math.PI/180);
			_velocity.y = onward * Math.sin(_car.rotation*Math.PI/180);
			_car.x += _velocity.x;
			_car.y += _velocity.y;
			if (!_isDriveing){
				_speed *= _friction;//摩擦力
			}
		}
		
	}
}
package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Maxim Sprey <gamitude@gmail.com>
	 */
	public class stick extends Sprite
	{
		// Stick properties 
		var mass:Number = 6;   //总质量  
		var len:Number = 3;    //总长度 
		var div:Number = 50;//节数
		var massDiv:Number = mass / div; //每一节的质量 
		var lenDiv:Number = len / div;  //每一节的长度 0.06米   
		// Circle properties 
		var cX:Number = 300;
		var cY:Number = 200;
		var cR:Number = 50;
		// World Characteristics 
		var g:Number = 9.81;   //重力加速度 
		var pm:Number = 100; // Pixels/meter  //像素相对 米的长度比例   总长度为3米 有50节  那么每节相当于1.5个像素 
		var dt:Number = 1 / 60;    //时间单位  帧频为60的画 dt 相当于一帧的时间 这是时间单位 
		// var itr:uint = 3; // Number of rigid body iterations 
		// Program Characteristics 
		var pX:Array = [];
		var pY:Array = [];
		var oX:Array = [];
		var oY:Array = [];
		var aX:Array = [];
		var aY:Array = [];
		
		var mS:Shape = new Shape();   //每一个点的形状  我在这里 只是当他为一个空点 然后每2个点之间用直线连接 
		
		public function stick():void
		{
			//初始化 速度 加速度 位移 
			for (var i:uint = 0; i <= div; i++)
			{
				// 初始化运动后坐标 
				pX[i] = 10 + (lenDiv * pm * i);
				pY[i] = 10;
				
				// 初始化运动前的坐标  
				oX[i] = 10 + (lenDiv * pm * i);
				oY[i] = 10;
				
				//初始化加速度 
				aX[i] = 0;
				aY[i] = 0;
			}
			addChild(mS);
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		public function frame(evt:Event):void
		{
			//固定开始点 
			pX[0] = 300;
			pY[0] = 200;
			//最后一个点跟随鼠标运动 
			pX[pX.length - 1] = stage.mouseX;
			pY[pY.length - 1] = stage.mouseY;
			
			//设置重力加速度 
			accForces();
			
			verlet();
			//判断是否碰到圆 然后做什么处理 
			//checkColl(); 
			for (var j:uint = 0; j <= div; j++)
			{
				satConstraints();
			}
			// Draw line 
			mS.graphics.clear();
			mS.graphics.lineStyle(1, 0x000000, 2);
			mS.graphics.moveTo(0, 0);
			mS.graphics.drawCircle(cX, cY, cR);
			mS.graphics.moveTo(0, 0);
			mS.graphics.moveTo(pX[0], pY[0]);
			
			pX[0] = 300;
			pY[0] = 200;
			
			pX[pX.length - 1] = stage.mouseX;
			pY[pY.length - 1] = stage.mouseY;
			//画圆或者 矩形 
			for (var i:uint = 0; i <= div; i++)
			{
				mS.graphics.lineTo(pX[i], pY[i]);
					//mS.graphics.drawRect(pX[i], pY[i], 0,0); 
			}
		}
		
		public function verlet():void
		{
			for (var i:uint = 0; i <= div; i++)
			{
				var tempX:Number = pX[i];
				pX[i] += (0.99 * pX[i] - 0.99 * oX[i]) + (aX[i] * pm * dt * dt);
				var tempY:Number = pY[i];
				pY[i] += (0.99 * pY[i] - 0.99 * oY[i]) + (aY[i] * pm * dt * dt);
				oX[i] = tempX;
				oY[i] = tempY;
			}
		}
		
		public function accForces():void
		{
			for (var i:uint = 1; i <= div; i++)
			{
				aY[i] = g;
			}
		}
		
		public function satConstraints():void
		{
			for (var i:uint = 1; i <= div; i++)
			{
				//两绳节间的距离
				var dx:Number = (pX[i] - pX[i - 1]) / pm;
				var dy:Number = (pY[i] - pY[i - 1]) / pm;
				var d:Number = Math.sqrt((dx * dx) + (dy * dy));
				
				var diff:Number = d - lenDiv;
				pX[i] -= (dx / d) * 0.5 * pm * diff;
				pY[i] -= (dy / d) * 0.5 * pm * diff;
				pX[i - 1] += (dx / d) * 0.5 * pm * diff;
				pY[i - 1] += (dy / d) * 0.5 * pm * diff;
			}
		}
		
		public function checkColl():void
		{
			for (var i:uint = 0; i <= div; i++)
			{
				var dx:Number = pX[i] - cX;
				var dy:Number = pY[i] - cY;
				var r:Number = Math.sqrt((dx * dx) + (dy * dy));
				//trace(r); 
				var rr:Number = r - cR;
				if (rr < 0)
				{
					// Collision 
					pX[i] += (-dx / r) * rr;
					pY[i] += (-dy / r) * rr;
				}
			}
		}
	}

}
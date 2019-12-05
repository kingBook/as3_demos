package  {
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	
	public class DrawPlus extends MovieClip {
		
		private var _txt:TextField;
		private var _mc:MovieClip;
		
		private var _sourceBmd:BitmapData;
		private var _canvasBmd:BitmapData;
		private var _canvasBmp:Bitmap;
		private var _canvasShape:Shape;
		private var _sourcePixelsCount:uint;
		
		
		
		public function DrawPlus() {
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			_txt=getChildByName("txt") as TextField;
			_txt.text="0%";
			_mc=getChildByName("mc") as MovieClip;
			_mc.visible=false;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		private function onMouseDownHandler(e:MouseEvent):void{
			if(_sourceBmd==null&&_canvasBmd==null){
				initDraw(_mc);
			}
		}
		
		private function initDraw(child:DisplayObject):void{
			var childRect:Rectangle=child.getBounds(child.parent);
			var childId:int=child.parent.getChildIndex(child);
			var childParent:DisplayObjectContainer=child.parent;
			
			_sourceBmd=getDisObjBmd(child);
			_sourcePixelsCount=getBmdColorPixelsCount(_sourceBmd,true);
			
			_canvasBmd=_sourceBmd.clone();
			//addChild(new Bitmap(_sourceBmd));
			_canvasBmp = new Bitmap(_canvasBmd);
			_canvasBmp.x=childRect.x;
			_canvasBmp.y=childRect.y;
			childParent.addChildAt(_canvasBmp,childId);
			childParent.removeChild(child);

			_canvasShape = new Shape();
			_canvasShape.x = childRect.x;
			_canvasShape.y = childRect.y;
			_canvasShape.visible=false;
			childParent.addChild(_canvasShape);

			_canvasShape.graphics.lineStyle(40);
			_canvasShape.graphics.lineBitmapStyle(_sourceBmd);
			_canvasShape.graphics.moveTo(_canvasShape.mouseX,_canvasShape.mouseY);
		}
		
		//var time:int
		private function update(e:Event):void{
			if(_sourceBmd&&_canvasBmd){
				_canvasShape.graphics.lineTo(_canvasShape.mouseX,_canvasShape.mouseY);
				_canvasBmd.fillRect(_canvasBmd.rect,0);//清空再画，否则有透明度的效果会叠加覆盖
				_canvasBmd.draw(_canvasShape);
				//time=flash.utils.getTimer();
				var rate:Number = checkBmd(_sourceBmd,_canvasBmd);
				//time=getTimer()-time; 
				//trace("time:"+time);
				_txt.text = int(rate*100)+"%";
				trace(rate);
			}
		}
		//var bmp:Bitmap;
		private function checkBmd(sourceBmd:BitmapData,canvasBmd:BitmapData):Number{
			var rate:Number=0;//0~1
			var result:*=sourceBmd.compare(canvasBmd);
			if(result==0){
				rate=1;
			}else{
				var tmpBmd:BitmapData=result as BitmapData;
				//bmp||=new Bitmap(tmpBmd);
				//bmp.bitmapData=tmpBmd;
				//stage.addChild(bmp);
				var count:uint=getBmdColorPixelsCount(tmpBmd);//剩余没涂的不透明像素数
				tmpBmd.dispose();//如果显示bmp就不要dispose
				/*if(count<=10){//没涂像素小于指定数量直接完成
					return 1;
				}*/
				count=_sourcePixelsCount-count;//已涂色的不透明像素数
				
				rate=count/_sourcePixelsCount;
			}
			return rate;
		}

		private function getDisObjBmd(disObj:DisplayObject):BitmapData{
			var r:Rectangle = disObj.getBounds(disObj);
			var bmd:BitmapData = new BitmapData(r.width,r.height,true,0);
			var matrix:Matrix = new Matrix(1,0,0,1,-r.x,-r.y);
			bmd.draw(disObj,matrix);
			return bmd;
		}
		
		/**
		 * 返回bitmapData不透明的像素数量
		 * @param	bmd
		 * @param	isClone 是否新建bmd副本，为了计算过程不改变bmd本身
		 * @return
		 */
		private function getBmdColorPixelsCount(bmd:BitmapData,isClone:Boolean=true):uint{
			if(isClone)bmd=bmd.clone();
			var threshold:uint=0x00000000;
			var color:uint=0xFF00FF00;
			var mask:uint=0xFF000000;
			var copySource:Boolean=false;
			var count:uint=bmd.threshold(bmd,bmd.rect,bmd.rect.topLeft,">",threshold,color,mask,copySource);
			if(isClone)bmd.dispose();
			return count;
		}
		
		private function dispose():void{
			if(_sourceBmd){
				_sourceBmd.dispose();
				_sourceBmd=null;
			}
			if(_canvasBmp){
				if(_canvasBmp.parent)_canvasBmp.parent.removeChild(_canvasBmp);
				_canvasBmp=null;
			}
			if(_canvasBmd){
				_canvasBmd.dispose();
				_canvasBmd=null;
			}
			if(_canvasShape){
				if(_canvasShape.parent)_canvasShape.parent.removeChild(_canvasShape);
				_canvasShape=null;
			}
		}
		
		
	}
}

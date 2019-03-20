package {
	import flash.display.Sprite;
	import com.bit101.components.TextArea;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;

	public class UIManager{
		private static var _instance:UIManager;
		public static function getInstance():UIManager{
			return _instance||=new UIManager();
		}
		
		private var _mainSp:Sprite;
		//
		private var _textArea:TextArea;
		private var _clearBtn:PushButton;
		public function init(mainSp:Sprite):void{
			_mainSp=mainSp;
			//
			_textArea=new TextArea(null,5,5,"");
			_mainSp.addChildAt(_textArea,0);
			
			_clearBtn=new PushButton(_mainSp,210,5,"clear",clearHandler);
			_clearBtn.setSize(50,20);
		}
		
		private function clearHandler(e:MouseEvent):void{
			_textArea.text="";
		}
		
		/**不支持打印中文*/
		public function print(... params):void{
			var text:String="";
			for(var i:int=0; i<params.length; i++) text+=params[i]+" ";
			_textArea.text+=text+"\n";
		}
		
	};
	
}
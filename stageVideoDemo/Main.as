package  {
	
	import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.events.Event;
    import flash.events.StageVideoAvailabilityEvent;
    import flash.display.Stage;
    import flash.media.StageVideoAvailability;
    import flash.media.StageVideo;
    import flash.events.StageVideoEvent;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import flash.net.NetStreamPlayOptions;
	
	public class Main extends Sprite {
		
		private var videoURL:String = "http://www.helpexamples.com/flash/video/cuepoints.flv";
		//private var videoURL:String = "http://www.helpexamples.com/flash/video/caption_video.flv";
		//private var videoURL:String = "http://192.168.1.103/children/xpg.flv";
        private var connection:NetConnection;
        private var stream:NetStream;
        private var video:Video = new Video();        
		private var stageVideo:StageVideo;
		private var isStageVideoAvailability:Boolean;
		
		public function Main() {
			super();
			if(!stage)addEventListener(Event.ADDED_TO_STAGE,init);
			else init();
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoAvailability);
			//
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			this.addEventListener(Event.ENTER_FRAME,enterFrame);
		}
		
		private function enterFrame(e:Event):void{
			///trace();
		}
		
		private function clickHandler(e:MouseEvent):void{
			var targetName:String=e.target.name;
			if(targetName=="playBtn"){
				play();
			}else if(targetName=="pauseBtn"){
				pause();
			}else if(targetName=="resumeBtn"){
				resume();
			}else if(targetName=="playTimeBtn"){
				var time:Number=Number(this["timeTxt"].text);
				playTime(time);
			}
		}
		
		private function onStageVideoAvailability(e:StageVideoAvailabilityEvent):void{
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoAvailability);
			//
			isStageVideoAvailability=e.availability==StageVideoAvailability.AVAILABLE;
			//
			connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}
		
		private function netStatusHandler(e:NetStatusEvent):void {
			//trace("netStatusHandler:",e.info.code);
            switch (e.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + videoURL);
                    break;
				case "NetStream.Play.Stop":
					trace("stop();");
					break;
            }
        }

        private function securityErrorHandler(e:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + e);
        }

        private function connectStream():void {
			if(!stream){
				stream = new NetStream(connection);
				stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.client = new CustomClient();
			}
			
			if(isStageVideoAvailability){
				if(!stageVideo){
					stageVideo=stage.stageVideos[0];
					stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoStateChange);
					
				}
				stageVideo.attachNetStream(stream);
			}else{
				addChild(video);
				video.attachNetStream(stream);
			}
        }
		
		private function play():void{
			stream.play(videoURL);
		}
		
		private function pause():void{
			stream.pause();
			trace(stream.time);
		}
		
		private function resume():void{
			stream.resume();
		}
		
		private function playTime(time:Number):void{
			stream.seek(time);
		}
		
		private function onStageVideoStateChange(e:StageVideoEvent):void{
			stageVideo.viewPort=new Rectangle(20,0,stage.stageWidth-40,stage.stageHeight);
		}

		
	};
	
}



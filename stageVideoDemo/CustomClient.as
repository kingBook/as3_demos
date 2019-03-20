package{
	public class CustomClient {
		public function onMetaData(info:Object):void {
			trace("onMetaData: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
		}
		public function onCuePoint(info:Object):void {
			trace("onCuePoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		public function onPlayStatus (info:Object):void{
			trace("onPlayStatus:",info);
		}
	};
}
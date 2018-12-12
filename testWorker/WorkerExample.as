package{
    import flash.events.Event;
    import flash.net.registerClassAlias;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.system.WorkerState;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    
    public class WorkerExample extends Sprite{
        
        [Embed(source="BackgroundWorker.swf", mimeType="application/octet-stream")]
        private static var BackgroundWorker_ByteClass:Class;
        
        private var bgWorker:Worker;
        private var bgWorkerCommandChannel:MessageChannel;
        private var resultChannel:MessageChannel;
        
        public function WorkerExample(){
			trace("===Worker.isSupported:",Worker.isSupported);
            initialize();
        }
        
        private function initialize():void{
            registerClassAlias("CountResult", CountResult);
            
            bgWorker = WorkerDomain.current.createWorker(new BackgroundWorker_ByteClass());
			//
            bgWorkerCommandChannel = Worker.current.createMessageChannel(bgWorker);
            bgWorker.setSharedProperty("incomingCommandChannel", bgWorkerCommandChannel);
                        
            resultChannel = bgWorker.createMessageChannel(Worker.current);
            resultChannel.addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
            bgWorker.setSharedProperty("resultChannel", resultChannel);
            //
            bgWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
            bgWorker.start();
        }
        
        private function handleBGWorkerStateChange(event:Event):void{
            if (bgWorker.state == WorkerState.RUNNING){
                bgWorkerCommandChannel.send(["startCount", 1]);
            }
        }
        
        private function handleResultMessage(event:Event):void{
            var result:CountResult = resultChannel.receive() as CountResult;
			trace("handleResultMessage:",result.countTarget);
           
        }
        
    }
}
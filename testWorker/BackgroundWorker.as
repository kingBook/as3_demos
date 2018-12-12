package {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.registerClassAlias;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    
    public class BackgroundWorker extends Sprite{
        private var commandChannel:MessageChannel;
        private var resultChannel:MessageChannel;
        
        public function BackgroundWorker(){
            initialize();
        }
        
        private function initialize():void{
            registerClassAlias("CountResult", CountResult);
            
            commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
			if(commandChannel){
				commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
			}
            //
            resultChannel = Worker.current.getSharedProperty("resultChannel") as MessageChannel;
        }        
        
        private function handleCommandMessage(event:Event):void{
            if (!commandChannel.messageAvailable)return;
            
            var message:Array = commandChannel.receive() as Array;
            if(message){
				if(message[0]=="startCount"){
					var result:CountResult=new CountResult();
					result.countTarget=message[1]+1;
					resultChannel.send(result);
				}
			}
			
        }
        
        
    };
}

package com.asvital.flash.core
{
	import com.asvital.ere.skin.Loading;
	
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CheckEnable
	{
		private static var stage:Stage;
		private static var text:TextField=new TextField;
		private static var timer:Timer = new Timer(1000*60*30);
		public function CheckEnable()
		{
		}
		public static function init(_stage:Stage,appName:String):void{
			stage = _stage;
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			timer.start();
			
			
			var urlloader:URLLoader = new URLLoader();		
			urlloader.addEventListener(Event.COMPLETE,onCompleteHandler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErrorHandler);
			
			
			var loading:Loading = new Loading();
			
			stage.addChild(loading);
			
			loading.x = stage.stageWidth/2;
			loading.y = stage.stageHeight/2;	
			loading.visible = false;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onEreCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			
			var lc:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			
			function onProgressHandler(event:ProgressEvent):void
			{
				loading.visible = true;
				loading.x = stage.stageWidth/2;
				loading.y = stage.stageHeight/2;
			}	
			function onEreCompleteHandler(event:Event):void{
					
				/*var ba:ByteArray = new ByteArray();
				ba.writeObject(loader.content);
				ba.position = 0;
				trace(ba.toString());*/
				loader.content.visible = false;
				stage.addChild(loader.content);
				
				if(loading.parent){
					loading.parent.removeChild(loading);
				}
			}
			function onIOErrorHandler(event:IOErrorEvent):void
			{
				text.defaultTextFormat = new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER);				
				text.border = true;
				text.width = stage.stageWidth;
				text.height = stage.stageHeight;
				text.borderColor = 0xffffff;
				text.background = true;
				text.text = "组件加载失败";
				//stage.stopAllMovieClips();				
				stage.removeChildren();
				stage.addChild(text);				
			
			}	
			onTimerHandler(null);
			
			function onTimerHandler(event:TimerEvent):void
			{
				//loader.load(new URLRequest("http://common.asvital.com/ERE.swf?appName="+appName),lc);		
				urlloader.load(new URLRequest("http://common.asvital.com/app/check?name=com.asvital.ere."+appName));
			}		
			
				
			
			
			//trace(appName);
			var timeOut:uint = 0;
			function onErrorHandler(event:IOErrorEvent):void
			{
				// TODO Auto-generated method stub
				//timeOut=setTimeout(reload,3000);
			}
			function reload():void{
				urlloader.load(new URLRequest("http://common.asvital.com/app/check?name=com.asvital.ere."+appName));
				clearTimeout(timeOut);
			}
			
			function onCompleteHandler(event:Event):void
			{
				clearTimeout(timeOut);
				
				//trace(Capabilities.manufacturer);
				//trace(Capabilities.version);
				var isAir:Boolean = true;
				try{
					if(stage.hasOwnProperty("orientation")){
						
					}else{
						isAir = false;
					}
					
				}catch(e:Error){
					//trace(e);
					isAir = false;
				}
				
				//trace(urlloader.data);
				var obj:Object = {};
				try{
				obj = JSON.parse(urlloader.data);
				}catch(e:Error){
					trace(e);
				}
				//trace(obj.data.name);
				if(obj.success==false){
					if(isAir){
						stage.removeChildren();
					}else{
						stage.removeChildren();
					}
					
				}else{
					//trace("---");
					//trace(obj.data.enable);
					if(obj.data!=null && obj.data.enable==false){
						if(isAir){
							stage.removeChildren();
						}else{
							stage.removeChildren();
						}
					}
				}
				
				
				
			}
			function onSecurityErrorHandler(event:SecurityErrorEvent):void
			{
				// TODO Auto-generated method stub
				
			}
		}
		
			
			
			
			
		
	}
}
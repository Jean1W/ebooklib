package com.asvital.flash.core.display
{
	import com.asvital.ere.skin.MusicIcon;
	import com.asvital.flash.core.AppGlobals;
	import com.asvital.flash.core.CheckEnable;
	import com.asvital.flash.core.EmbedResource;
	import com.asvital.flash.core.manager.FocusManager;
	import com.asvital.flash.core.utils.BitmapUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextSnapshot;
	import flash.ui.Mouse;

	public class Application extends BaseDispaly
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var close:SimpleButton;
		private var museicon:MusicIcon;
		private var bg:Sprite;
		public function Application(w:Number, h:Number,appName:String,focus:Boolean=false,isAir:Boolean=true)
		{
			super(w, h);
			
			if(stage){
				onStageHandler(null);
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
			}
			
			
			
			if(AppGlobals.isAir==true && isAir!=true){
				AppGlobals.isAir = isAir;
			}
			
			
			bg = new Sprite();
			super.addChild(bg);
			
			
			
		
			
			if(appName!="" && appName!=null){
				CheckEnable.init(stage,appName);
			}			
			
			AppGlobals.topLevelApplication = this;
			
			if(focus){				
				focusManager = new FocusManager(this);
			}
			
			middler.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);			
			
			close =  new SimpleButton(BitmapUtil.getBitmapByClass(EmbedResource.CloseUp),BitmapUtil.getBitmapByClass(EmbedResource.CloseDown),BitmapUtil.getBitmapByClass(EmbedResource.CloseDown),BitmapUtil.getBitmapByClass(EmbedResource.CloseDown));
			close.x = w-close.width-5;
			close.y = h-close.width-5;
			close.addEventListener(MouseEvent.CLICK,onCloseHandler);
			toper.addChild(close);
			
			//this.addEventListener(Event.ADDED,onAddHandler,true);		
			
			if(AppGlobals.isAir){
				readConfigAir();
			}else{
				readConfigWeb();
			}
			
			
						
			
		}
		
		protected function onStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
		}
		
		protected function showMask():void{
		
			//var LM:DisplayObject  = EmbedResource.LogoMask;
			var lm:Bitmap = new EmbedResource.LogoMask;
			
			var slm:Sprite = new Sprite();
			slm.addChild(lm);
			
			slm.mouseEnabled = false;
			slm.mouseChildren = false;
			middler.addChild(slm);
			
		}

		

		/**
		 * 
		 * @param day 从第一次运行开始计算，超过使用的天数，如果没有打开的话，就不算
		 * 
		 */		
		public function setTimeOut(day:int):void{
			
			var file:File = File.applicationStorageDirectory.resolvePath("data");	
			if(file.parent){
				if(file.parent.exists){
					if(file.exists==false){
						//NativeApplication.nativeApplication.exit(0);
						//return;
					}
				}
				
			}
			//trace(file.exists);
			if(file.exists){
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var arr:Array = [];				
				while(true){
					if(fs.bytesAvailable==0){
						break;
					}
					if(fs){
						
					}
					var se:Array = [];
					se.push(fs.readInt());
					se.push(fs.readInt());
					se.push(fs.readInt());
					arr.push(se);
				}
				fs.close();
				if(arr.length>=day){
					NativeApplication.nativeApplication.exit(0);
					return;
				}
				var data:Date = new Date();
				var ishave:Boolean =false;
				for(var i:int=0;i<arr.length;i++){
					var ll:Array = arr[i];
					if(ll[0]==data.getFullYear() && ll[1]==data.getMonth()+1 && ll[2]==data.getDate()){
						ishave = true;									
					}
				}
				
				if(ishave==false){
					fs.open(file,FileMode.APPEND);
					fs.writeInt(data.getFullYear());
					fs.writeInt(data.getMonth()+1);
					fs.writeInt(data.getDate());		
					fs.close();
				}			
				
			}else{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.WRITE);
				var data:Date = new Date();
				trace(data.getFullYear(),data.getMonth(),data.getDate());
				fs.writeInt(data.getFullYear());
				fs.writeInt(data.getMonth()+1);
				fs.writeInt(data.getDate());		
				fs.close();
			}
			
				
			
			
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(clickEffectSound){
				clickEffectSound.play(0,0);
			}
			
		}
		private var clickEffectSound:Sound;
		public function enableClickEffect(url:String):void{
			
			if(clickEffectSound==null){
				clickEffectSound = new Sound();
				clickEffectSound.addEventListener(IOErrorEvent.IO_ERROR,onSoundIOErrorHandler);
				clickEffectSound.load(new URLRequest(url),new SoundLoaderContext());	
				//stage.addEventListener(MouseEvent.CLICK,onClickHandler,true);
				//stage.addEventListener(MouseEvent.CLICK,onClickHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP,onClickHandler);
				//soundChannel=clickEffectSound.play(0);
			}
		}
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			
			if(event.keyCode==27){
				event.preventDefault();
			}
			
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			
			return middler.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			
			return middler.addChildAt(child, index);
		}
		
		override public function areInaccessibleObjectsUnderPoint(point:Point):Boolean
		{
			
			return middler.areInaccessibleObjectsUnderPoint(point);
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			
			return middler.contains(child);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			
			return middler.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			
			return middler.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			
			return middler.getChildIndex(child);
		}
		
		override public function getObjectsUnderPoint(point:Point):Array
		{
			
			return middler.getObjectsUnderPoint(point);
		}
		
		override public function get mouseChildren():Boolean
		{
			
			return middler.mouseChildren;
		}
		
		override public function set mouseChildren(enable:Boolean):void
		{
			
			middler.mouseChildren = enable;
		}
		
		override public function get numChildren():int
		{
			//throw new Error("please use container numChildren method!");
			return middler.numChildren;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			
			return middler.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			
			return middler.removeChildAt(index);
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=2147483647):void
		{
			
			middler.removeChildren(beginIndex, endIndex);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			
			middler.setChildIndex(child, index);
		}
		
		/*override public function stopAllMovieClips():void
		{
			throw new Error("please use container stopAllMovieClips method!");
			super.stopAllMovieClips();
		}*/
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			
			middler.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			
			middler.swapChildrenAt(index1, index2);
		}
		
		override public function get tabChildren():Boolean
		{
			
			return middler.tabChildren;
		}
		
		override public function set tabChildren(enable:Boolean):void
		{
			
			middler.tabChildren = enable;
		}
		
		override public function get textSnapshot():TextSnapshot
		{
			
			return middler.textSnapshot;
		}
		
		
		private var backgroundMusicSoundTransform:SoundTransform;
		
		private function readConfigWeb():void{
			var urlloader:URLLoader = new URLLoader();
			function onConfigLoadOverHandler(event:Event):void
			{
				trace(urlloader.data);
				
			}
			
			urlloader.addEventListener(Event.COMPLETE,onConfigLoadOverHandler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{trace(event);});
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(event:SecurityErrorEvent):void{trace(event);});
			try{
				urlloader.load(new URLRequest("config.xml"));
			}catch(e:Error){
				trace(e);
			}
		}
		
		
		private function readConfig(context:String):void{
			
			var configXML:XML = XML(context);
			if(int(configXML.debug)==1){				
				this.scaleX = this.scaleY = configXML.scale;
				if(int(configXML.mouse_visible)==0){
					Mouse.hide();
				}else{
					
				}
			}			
			stage.frameRate = configXML.stageRate;				
			Sequence.SequenceRate =configXML.sequenceRate; 
			trace(configXML.background.music.@src);
			
			backgroundMusicSoundTransform = new SoundTransform(Number(configXML.background.music.@volume));
			backgroundSound(configXML.background.music.@src,false,int.MAX_VALUE,backgroundMusicSoundTransform);
			
			trace(configXML.background.image.@src);
			if(configXML.background.image.@src!=""){
				
				//var file:File = File.applicationDirectory.resolvePath("");
				var loader:Loader = new Loader();
				loader.load(new URLRequest(configXML.background.image.@src));
				bg.addChild(loader);
				
			}
			
			
			//full_screen
			if(int(configXML.full_screen)>0){
				this.setFullScreen();
			}
		}
		private function readConfigAir():void
		{
			var context:String;
			var configFile:File = File.applicationDirectory.resolvePath("config.xml");
			if(configFile.exists){
				var fie:FileStream = new FileStream();
				fie.open(configFile,FileMode.READ);
				//trace(fie.readUTFBytes(fie.bytesAvailable));
				context = fie.readUTFBytes(fie.bytesAvailable);		
				readConfig(context);
				
			}	
			
			
			
		}		 
		public function hideMusicICON(val:Boolean = false):void{
		
			if(museicon){
				museicon.visible = val;
			}
		}
		private function onMouseMoveHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			middler.addChild(close);
			if(museicon){
				middler.addChild(museicon);
			}
			
		}
		
		private function onCloseHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(AppGlobals.isAir){
				NativeApplication.nativeApplication.exit(0);
			}
			
		}		
		
		public function setFullScreen():void{
			if(stage){
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}
		private var soundPostion:int=0;
		private var loop:int = 0;
		private var bgSoundTransform:SoundTransform;
		private var musicBgPause:Boolean =false;
		public function backgroundSound(source:String,icon:Boolean=false,loop:int=0,soundTransform:SoundTransform=null,soundLoaderContext:SoundLoaderContext=null):SoundChannel{
			this.loop = loop;
			this.bgSoundTransform = soundTransform;
			
			if(sound==null && museicon==null){
				sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR,onSoundIOErrorHandler);
				sound.load(new URLRequest(source),soundLoaderContext);
				soundChannel = sound.play(0,loop,soundTransform);	
				museicon = new MusicIcon();
				museicon.width =museicon.height = 64;
				museicon.x = museicon.width/2;
				museicon.y = museicon.height/2;
				museicon.addEventListener(MouseEvent.CLICK,onMusicIconClickHandler);
				 
			}
			middler.addChild(museicon);
			return soundChannel;
			
		}
		
		protected function onMusicIconClickHandler(event:MouseEvent):void
		{
			if(musicBgPause==false){
				museicon.stop();
				soundPostion = soundChannel.position;
				soundChannel.stop();				
				
				musicBgPause = true;
			}else{
				museicon.play();
				soundChannel = sound.play(soundPostion,loop,bgSoundTransform);
				musicBgPause = false;
			}
			//soundChannel.stop();
		}
		
		private function onSoundIOErrorHandler(event:IOErrorEvent):void
		{
			trace(event.toString());
			museicon.visible = false;
		}
	}
}
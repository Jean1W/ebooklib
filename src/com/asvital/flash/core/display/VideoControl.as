package com.asvital.flash.core.display
{
	import com.asvital.flash.core.EmbedResource;
	import com.asvital.flash.core.events.VideoEvent;
	import com.asvital.flash.core.utils.BitmapUtil;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	[Event(name="over", type="com.asvital.flash.core.events.VideoEvent")]
	[Event(name="seek_over", type="com.asvital.flash.core.events.VideoEvent")]
	[Event(name="cue_point", type="com.asvital.flash.core.events.VideoEvent")]
	public class VideoControl extends BaseDispaly
	{
		private var line:Sprite;
		private var lineBg:Sprite;
		private var bg:Sprite;
		private var ns:NetStream;
		private var bar:Sprite;
		private var dragBar:Boolean =false;
		private var backButton:SimpleButton;
		private var uivideo:UIVideo;
		private var box:Sprite;
		public function VideoControl(w:Number, h:Number)
		{
			super(w, h);
			
			box = new Sprite();
			this.addChild(box);
			
			line = new Sprite();
			line.graphics.beginFill(0x0000ff);
			line.graphics.drawRect(0,0,this.edgeWidth/3,2);
			line.graphics.endFill();
			line.mouseEnabled = false;
			line.mouseChildren = false;		
			
			//this.edgeWidth/3,50
			
			lineBg = new Sprite();
			lineBg.graphics.beginFill(0x000000,0.4);
			lineBg.graphics.drawRect(0,0,this.edgeWidth/3,2);
			lineBg.graphics.endFill();
			lineBg.mouseEnabled = false;
			lineBg.mouseChildren = false;
			
			
			
			bar = new Sprite();
			bar.graphics.lineStyle(1,0x888888);
			bar.graphics.beginFill(0xffffff);
			bar.graphics.drawCircle(0,0,10);
			bar.graphics.endFill();		
			bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarMouseDownHandler);
			bar.addEventListener(MouseEvent.MOUSE_UP,onBarMouseUpHandler);
			
			
			
			bg = new Sprite();
			bg.graphics.beginFill(0x000000,0);
			bg.graphics.lineStyle(1,0x000000,0,true);
			//control.graphics.drawRect(0,0,this.edgeWidth,this.edgeHeight);
			bg.graphics.drawRoundRect(0,0,this.edgeWidth/3,50,10,10);
			bg.graphics.endFill();
			
			
			bg.addEventListener(MouseEvent.MOUSE_DOWN,onBarMouseDownHandler);
			bg.addEventListener(MouseEvent.MOUSE_UP,onBarMouseUpHandler);
			//bg.addEventListener(MouseEvent.RELEASE_OUTSIDE,onBarMouseUpHandler);
			
			
			bar.buttonMode = true;		
			
			
			
			
			
			backButton = new SimpleButton(BitmapUtil.getBitmapByClass(EmbedResource.boxCloseUp),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseUp),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseDown),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseDown));
			backButton.x = this.edgeWidth-backButton.width-10;
			backButton.y = 10;
			backButton.addEventListener(MouseEvent.CLICK,onBackButtonHandler);
			this.addChild(backButton);
			
			box.addChild(bg);
			box.addChild(lineBg);
			box.addChild(line);
			box.addChild(bar);
			
			//trace(box.height,box.width);
			
			lineBg.y =line.y=bar.y= 25;
			box.x = (this.edgeWidth-box.width)/2;
			box.y = this.edgeHeight-box.height-50
		}
		
		private function onBackButtonHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.stop();
			if(uivideo){
				uivideo.visible = false;
			}
			
			
			
		}
		public function init(ns:NetStream,uivideo:UIVideo):void{
			this.uivideo = uivideo;
			this.ns =ns;	
			ns.addEventListener(NetStatusEvent.NET_STATUS,onStatusHandler);
			this.ns.client = this;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			
			uivideo.addEventListener(MouseEvent.CLICK,onPauseHandler);
		}
		
		private function onPauseHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(playing){
				this.pause();
			}else{
				this.resume();
			}
			
			
		}
		protected function onBarMouseUpHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onBarMouseMoveHandler);			
			this.dragBar = false;
			
			var sessd:Boolean = this.dispatchEvent(new VideoEvent(VideoEvent.SEEK_OVER));
			if(sessd){
				this.ns.resume();
			}	
			
		}
		
		protected function onBarMouseDownHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.dragBar = true;
			this.ns.pause();
			ns.seek(this.duration*(box.mouseX/this.bg.width));
			this.addEventListener(MouseEvent.MOUSE_MOVE,onBarMouseMoveHandler);
			trace(this.mouseX);
		}
		
		protected function onBarMouseMoveHandler(event:MouseEvent):void
		{
			ns.seek(this.duration*(box.mouseX/this.bg.width));			
		}
		
		public function get canSkip():Boolean
		{
			return _canSkip;
		}

		public function set canSkip(value:Boolean):void
		{
			_canSkip = value;
		}

		protected function onStatusHandler(event:NetStatusEvent):void
		{
			trace(event.info.code,"---");
			switch(event.info.code){						
				case "NetStream.Seek.Notify":
				case "NetStream.Seek.Complete":					
					ns.resume();
					
					break;
				case "NetStream.Buffer.Full":
					
					break;
				case "NetStream.Play.Stop":
					
					this.dispatchEvent(new VideoEvent(VideoEvent.OVER));
					
					break;
			}
			
		}
		private var kk:Number = Math.random()*99;
		protected function onEnterFrameHandler(event:Event):void
		{
			//trace((ns.time/this.duration));
			//trace(this.stage);
			if(this.stage==null){
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			
			
			if(dragBar){
				this.bar.x = box.mouseX;
			}else{
				this.bar.x = (this.edgeWidth/3)*(ns.time/this.duration);
			}
			if(this.bar.x<0){
				this.bar.x=0;
			}
			if(this.bar.x>bg.width){
				this.bar.x = bg.width;
			}
			line.graphics.clear();
			//line.graphics.lineStyle(1,0xffffff);
			line.graphics.beginFill(0xffffff,1);
			line.graphics.drawRect(0,0,this.bar.x,2);
			line.graphics.endFill();	
			
			if(ns.time>=(duration-uivideo.overStop)){
				
				//uivideo.replayCount
				var nse:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{code:"NetStream.Play.Stop"});
				onStatusHandler(nse);
				
			}
			
			//ns.seek(duration-uivideo.overStop);
			
			//ns.seek(duration-uivideo.overStop);		
			
		}		
		public function setTime(ct:Number):void{
			
		}
		public function onCuePoint(obj:Object):void{
			trace(obj);
			this.dispatchEvent(new VideoEvent(VideoEvent.CUE_POINT,obj));
		}
		public function onXMPData(obj:Object):void{
			trace(obj);
		}
		public function onImageData(obj:Object):void{
			trace(obj);
		}
		public function onPlayStatus(obj:Object):void{
			trace(obj);
		}
		private var duration:Number = 0;
		private var _canSkip:Boolean = false;
		public function onMetaData(info:Object):void{
			trace(info);
			duration = info.duration;			
			if(_canSkip){
				this.addEventListener(MouseEvent.MOUSE_DOWN,onSkipHandler);
				
			}
		}
		public function replay():void{			
			if(ns){
				//ns.play(path);
				//playing = true;			
				ns.pause();
				ns.seek(0);
				//ns.resume();
			}
		}
		public function playOver():void{
			if(ns){
				//ns.play(path);
				//playing = true;			
				ns.pause();
				ns.seek(duration-uivideo.overStop);
				//ns.seek(duration-uivideo.overStop);
				//ns.resume();
			}
		}
		private var playing:Boolean =true;
		public function stop():void{
			if(ns){
				ns.close();
				playing = false;
			}
		}
		public function pause():void{
			
			if(ns){
				ns.pause();
				playing = false;
			}
		}
		public function resume():void{
			if(ns){
				ns.resume();
				playing = true;
			}
		}
		protected function onSkipHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}
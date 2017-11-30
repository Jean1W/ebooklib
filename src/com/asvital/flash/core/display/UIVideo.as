package com.asvital.flash.core.display
{
	import com.asvital.flash.core.events.VideoEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	//[Event(name="over", type="com.asvital.ere.events.VideoEvent")]
	[Event(name="ready", type="com.asvital.flash.core.events.VideoEvent")]
	public class UIVideo extends BaseDispaly
	{
		private var video:Video;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var _path:String = "";
		private var canSkip:Boolean = false;
		private var _replayCount:int = 0;
		private var _overStop:Number = 1;
		private var currentReplayCount:int =0;
		private var path:String;
		private var _playing:Boolean = false;
		private var _control:VideoControl;
		public function UIVideo(width:int = 320,height:int = 240)
		{
			super(width,height);
			_control = new VideoControl(this.edgeWidth,this.edgeHeight);
			_control.addEventListener(VideoEvent.OVER,onVideoOverHandler);
			
			video = new Video(width,height);
			video.smoothing = true;
			//video.opaqueBackground =0x00000000;
			//video.blendMode=BlendMode.ADD;
			this.addChild(video);
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS,onStatusHandler);
			nc.connect(null);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStageHandler);
			//this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);	
			_control.visible =false;
			
			
			
			//_control.y = this.edgeHeight-_control.height-50;
			
			
			
		}				
		
		public function get replayCount():int
		{
			return _replayCount;
		}

		public function get overStop():Number
		{
			return _overStop;
		}

		protected function onVideoOverHandler(event:VideoEvent):void
		{
			if(replayCount<0){				
				this.control.replay();				
			}
						
		}
		public function get control():VideoControl
		{
			return _control;
		}

		protected function onEnterFrameHandler(event:Event):void
		{
			if(ns!=null){
				//this.control.setTime(ns.time);
			}
			/*if(ns!=null && duration!=0 && playing && ns.time>=this.duration-0.1){
				playing = false;
				ns.pause();
				if(replayCount==-1){
					//video.clear();
					//ns.pause();//先暂停播放	
					
					//ns.play(path);
					ns.seek(0.1);					
					//ns.pause();
					
					//清除视频内容	
					
				}else if(replayCount==0){
					playing = false;
					this.dispatchEvent(new VideoEvent(VideoEvent.OVER));
				}else{
					
					if(currentReplayCount>replayCount){
						playing = false;
						this.dispatchEvent(new VideoEvent(VideoEvent.OVER));
					}else{
						//ns.play(path);
						ns.seek(0.1);
						playing = true;
						//ns.resume();
						currentReplayCount++;
					}						
				}
			}	*/		
						
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}

		public function set playing(value:Boolean):void
		{
			_playing = value;
		}

		protected function onRemoveStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("remove stage");
			if(ns){
				ns.pause();
			}
		}
		
		protected function onAddStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("add stage");
			if(ns){
				ns.resume();
			}
		}
		
		public function setSkip(skip:Boolean):void{
			this.canSkip = skip;
		}
		/**
		 * 
		 * @param path
		 * @param repaly -1=无限次数 0 来重播
		 * @param overStop 离结束几秒停止
		 * 
		 */		
		public function play(path:String,repaly:int=0,overStop:Number=0):void{
			_replayCount = repaly;
			this.path = path;
			this._overStop = overStop;
			if(ns){
				if(path!=null && path!=null){
					ns.play(path);					
					playing = true;
				}
			}
			
			_path = path;
			//this.dispatchEvent(new VideoEvent(VideoEvent.OVER));			
		}		
		
		protected function onSkipHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//ns.seek(duration-0.1);
		}
		
		private function onStatusHandler(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			trace(event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					ns = new NetStream(nc);
					//ns.addEventListener(NetStatusEvent.NET_STATUS,onStatusHandler);
					
					_control.init(ns,this);
					//_control.x = (this.edgeWidth-_control.width)/2;
					//_control.y = this.edgeHeight-_control.height-70;
					this.addChild(_control);
					this.dispatchEvent(new VideoEvent(VideoEvent.READY));						
									
					//ns.client = this;
					if(_path!=null && _path!=null){
						ns.play(_path);
						playing = true;
					}					
					this.video.attachNetStream(ns);						
					break;
				
			}
			
		}
		
		override protected function initView():void
		{
			
			
		}
		
	}
}
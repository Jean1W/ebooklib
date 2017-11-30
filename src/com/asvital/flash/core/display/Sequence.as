package com.asvital.flash.core.display
{
	import com.asvital.flash.core.EmbedResource;
	import com.asvital.flash.core.events.OperationEvent;
	import com.asvital.flash.core.utils.BitmapUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	[Event(name="complete", type="com.asvital.flash.core.events.OperationEvent")]
	
	public class Sequence extends BaseDispaly
	{
		
		private var index:int = 0;
		private var bitmap:Bitmap=new Bitmap();
		
		
		private var path:String;
		private var prefix:String;
		private var startFileName:String;
		private var format:String;
		
		private var load:Loader =new Loader();
		private var autoPlay:Boolean = false;
		private var loopPlay:Boolean = false;
		
		private var w:int = 0;
		private var h:int = 0;
		private var _isLoad:Boolean = false;
		private var mouseTimer:uint;
	
		private var isLeft:Boolean = false;
		private var _totalSequence:int =0;
		private var control:Boolean = false;
		
		[Embed(source="../../../../../assets/turn/turn_left.png")]
		private var TurnLeft:Class;
		[Embed(source="../../../../../assets/turn/turn_right.png")]
		private var TurnRight:Class;
		
		private var turn:BaseDispaly;
		
		private var turnLeft:Bitmap;
		private var turnRight:Bitmap;
		
		public static var SequenceRate:int=60;
		
		private var contenter:Sprite;

		private var backButton:SimpleButton;
		public function Sequence(w:int,h:int,_showBackButton:Boolean=false)
		{
			super(w,h);

			this.w = w;
			this.h = h;			
			
			contenter =new Sprite;
			this.addChild(contenter);
			
			
			
			if(_showBackButton){
				backButton = new SimpleButton(BitmapUtil.getBitmapByClass(EmbedResource.boxCloseUp),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseUp),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseDown),BitmapUtil.getBitmapByClass(EmbedResource.boxCloseDown));
				backButton.x = this.edgeWidth-backButton.width-10;
				backButton.y = 10;
				backButton.addEventListener(MouseEvent.CLICK,onBackButtonHandler);
				this.addChild(backButton);
			}
			
			turn = new BaseDispaly(w,h);
			
			var sp:Shape = new Shape();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(0,0,w,h);
			sp.graphics.endFill();
			contenter.addChild(sp);
			
			
			turnLeft =BitmapUtil.getBitmapByClassScale(TurnLeft,0.15);
			turnRight = BitmapUtil.getBitmapByClassScale(TurnRight,0.15);
			
			turnLeft.alpha = 0.5;
			turnRight.alpha = 0.5;
			
			
			//turnLeft.scaleX = turnLeft.scaleY =turnRight.scaleX = turnRight.scaleY= 0.15;
			
			turnLeft.x = w/2-turnLeft.width-25;
			turnRight.x = w/2+25;
			
			turn.addChild(turnLeft);
			turn.addChild(turnRight);
			turn.mouseChildren = false;
			turn.mouseEnabled = false;
			//turn.alpha = 0.5;
			turn.visible = false;
			
			
			turn.y = h-turn.height-50;
			
			
			
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler);			
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseUpHandler);
			//this.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMouseUpHandler);
			this.addEventListener(MouseEvent.CLICK,onClickHandler);
			
		}	
		
		protected function onBackButtonHandler(event:MouseEvent):void
		{
			this.visible = false;		
			
		}
		public function showBackButtom():void{
			
		}
		private var keyboardControl:Boolean = false;

		public function get totalSequence():int
		{
			return _totalSequence;
		}

		public function set totalSequence(value:int):void
		{
			_totalSequence = value;
		}

		public function setKeyboardControl(con:Boolean):void{
			this.keyboardControl = con;
			if(keyboardControl){
				this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
				this.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
			}else{
				this.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			}
		}
		
		protected function onKeyUpHandler(event:KeyboardEvent):void
		{
			
			removeEventListener(Event.ENTER_FRAME,onKeyboardEnterFrameHandler);
		}
		
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			
			if(event.keyCode==Keyboard.DOWN){			
				
				isLeft = true;
				addEventListener(Event.ENTER_FRAME,onKeyboardEnterFrameHandler);
			}else if(event.keyCode==Keyboard.UP){			
			
				isLeft = false;
				addEventListener(Event.ENTER_FRAME,onKeyboardEnterFrameHandler);
				
			}
			
			//trace(event.keyCode);
		}
		
		protected function onKeyboardEnterFrameHandler(event:Event):void
		{
			if(_isLoad==true){
				return;
			}
			if(isLeft){
				
				index--;				
				turnRight.alpha = 1;
				playIndex(index);
				
			}else{
				index++;				
				turnLeft.alpha = 1;
				playIndex(index);
				
			}
			
		}
		protected function onClickHandler(event:MouseEvent):void
		{
			
			if(this.autoPlay){
				//this.setAutoPlay(false);
			}else{
				//this.setAutoPlay(true);
				//this.playIndex(this.index);
			}
			
		}
		
		public function get isLoad():Boolean
		{
			return _isLoad;
		}
		public static function setConfig(sequenceRate:int):void{
			
			Sequence.SequenceRate = sequenceRate;
		}

		protected function onErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace(event);
		}
		public function setTurnTip(b:Boolean):void{
			
			if(b){				
				this.turn.visible = true;			
			}else{
				this.turn.visible = false;
			}
		}
		
		private function onCompleteHandler(event:Event):void
		{
			//trace(this.load.contentLoaderInfo.url);
			var time:Number = 1000/frameRate;			
			
			var sRate:Number = 1000/SequenceRate;
			
			var ni:Number = sRate-time;
			if(ni<0){
				ni = 0;
			}
			if(stage==null){
				return;
			}
			if(isFirst){
				isFirst = false;
				//loadTime = setTimeout(nextLoad,ni);
				nextLoad();
			}else{
				loadTime = setTimeout(nextLoad,ni);
			}
			
			
			
		}
		protected function redrowItem(index:int,item:DisplayObject,container:DisplayObjectContainer):void{
		
			
		}
		private function nextLoad():void{
			clearTimeout(loadTime);
			
			if(load.content==null){
				return;
			}
			
			_isLoad = false;
			var k:Bitmap = load.content as Bitmap;
			k.smoothing = true;
			bitmap.bitmapData = k.bitmapData;

			//this.contenter.addChild(k);
			
			redrowItem(index,k,this);
			
			if(autoPlay){
				if(control){
					if(this.mousePaly){
						this.index ++;
						this.playIndex(index);
					}
				}else{
					this.index ++;
					this.playIndex(index);
				}				
				
			}else{
				if(this.mousePaly){
					this.index ++;
					this.playIndex(index);
				}
				
			}
			
			
			
			
			this.bitmap.width = w;
			this.bitmap.height =h;
		
		}
		protected function onMouseUpHandler(event:MouseEvent):void
		{
			turnLeft.alpha =0.5;
			turnRight.alpha =0.5;
			
			// TODO Auto-generated method stub
			clearTimeout(mouseTimer);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME,onEFHandler);
			
			//trace(Point.distance(this.currentPoint,new Point(mouseX,mouseY)));
			if(Point.distance(this.currentPoint,new Point(mouseX,mouseY))==0){
				
				if(control){
					mousePaly = !mousePaly;				
					//trace(event);				
					if(mousePaly){
						this.playIndex(this.index);
					}
				}				
				
			}
		}
		private var currentPoint:Point = new Point();
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			
			currentPoint.x = mouseX;
			currentPoint.y = mouseY;
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
			//trace(event);
			
			mouseTimer = setTimeout(function():void{
				clearTimeout(mouseTimer);
				
				//removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
				
				addEventListener(Event.ENTER_FRAME,onEFHandler);
				
			},200);
		}		
		private function onEFHandler(e:Event):void{
			if(isLeft){
				currentPoint.x = mouseX-2;
			}else{
				currentPoint.x = mouseX+2;
			}
			
			onMouseMoveHandler(null);
			trace(index);
		}
		
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
			
			
			if(_isLoad==false){
				if(Math.abs(mouseX-currentPoint.x)>1){
					
					if(mouseX-currentPoint.x<0){						
						index++;
						isLeft = false;
						turnLeft.alpha = 1;
					}else{
						index--;
						isLeft = true;
						turnRight.alpha = 1;
					}
					playIndex(index);
					
				}	
				
			}
			
			currentPoint.x= mouseX;
			//event.updateAfterEvent();
		}		
		
		override protected function initView():void
		{
			contenter.addChild(bitmap);
			contenter.addChild(turn);			
			
		}
		
		private var loadTime:uint;
		public function gotoPlay(per:Number):void{

			if(totalSequence==0){
				return
			}
            per = Math.min(per,100)
            per = Math.max(per,0)

            var pindex:int = totalSequence*(per/100);
            playIndex(pindex);

		}
		private function playIndex(_index:int=0):void{
			
			if(this.visible==false){
				return;
			}
			var path:String = getPath(_index);
			//trace(File.applicationDirectory.resolvePath(path).nativePath)
			if(File.applicationDirectory.resolvePath(path).exists){
				
				
					
					_isLoad = true;
					load.load(new URLRequest(path));
					
					totalSequence = Math.max(totalSequence,_index);
					index= _index;
										
					load.load(new URLRequest(path));			
				
				
			}else{
				
				if(loopPlay){
					
					
					if(_index<0){
						index = totalSequence-1;
						//this.playIndex(index);
					}else{
						trace("没有找到图片："+path);
					}
					if(_index>=totalSequence){
						index = 0;
						//this.playIndex(index);
					}
					
					path = getPath(index);
					_isLoad = true;
					
					load.load(new URLRequest(path));
					
					
					
					
				}else{
					if(control){
						mousePaly = false;
					}				
					
					if(_index==0){
						trace("没有找到图片："+path);
					}
					if(index<0){
						index = 0;
					}
					if(index>totalSequence){
						index=totalSequence;
					}
						
					//this.index = totalFrame;
					//this.playIndex(index);
					this.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE));
					
				}
				if(control){
					//this.setAutoPlay(false);
				}
			}
			//trace(index);			
		}
		private var mousePaly:Boolean = false;
		public function setMouseControl(control:Boolean):void{
			this.control = control;
			
			if(this.control){
				//setAutoPlay(false);
				//setLoopPlay(false);
				
				
			}else{
				
			}
			
			
		}
		
		
		public function setAutoPlay(autoPlay:Boolean):void{
		
			this.autoPlay = autoPlay;
			
		}	
		public function setLoopPlay(loopPlay:Boolean):void{
		
			this.loopPlay = loopPlay;
		}
		private var isFirst:Boolean = false;
		public function setConfig(path:String,prefix:String,startFileName:String="0000",format:String="jpg"):void{
			
			if(this.visible==false){
				
				throw new Error("序列帧图层不可见，无法看到效果。");
			}
			
			isFirst = true;
			this.path = path;
			this.prefix = prefix;
			this.startFileName = startFileName;
			this.format = format;		
			
			this.playIndex();
			
			this.alpha = 0;		
			
			
			
			totalSequence = File.applicationDirectory.resolvePath(path).getDirectoryListing().length;
			
			
			TweenLite.to(this,1,{alpha:1});
			
			mousePaly=this.autoPlay;			
		}		
		
		private function getPath(_index:int):String{
		
			var startIndex:int = startFileName.length-String(_index).length;
			if(startIndex<0){
				//throw new Error("超出索引范围");
				startIndex = 0;
			}
			//trace(startIndex);
			var FN:String = startFileName.substr(0,startIndex)+String(_index);
			
			
			return path+"/"+prefix+FN+"."+format;
			
		}
	}
}
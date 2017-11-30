package com.asvital.flash.core.display
{
import com.asvital.flash.core.events.OperationEvent;
import com.asvital.flash.core.utils.BitmapUtil;
	import com.greensock.TweenLite;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class ImageView extends BaseDispaly
	{
		protected var _edgeWidth:int =0;
		protected var _edgeHeight:int =0;
		
		private var path:String;
		private var prefix:String;
		private var startFileName:String;
		private var format:String;
		private var load:Loader =new Loader();
		
		
		[Embed(source="../../../../../assets/turn/left.png")]
		private var TurnLeft:Class;
		[Embed(source="../../../../../assets/turn/right.png")]
		private var TurnRight:Class;
		
		
		private var left:DisplayObject;
		private var right:DisplayObject;

		
		private var index:int = 0;
		private var totalFrame:int =0;
		private var area:AutoFitArea;
		private var container:Sprite;
		protected var screenCount:int =1;
		private var scaleMode:String;
		private var downPoint:Point;
		private var point:Point;
		private var tweent:TweenLite;
		private var antTime:Number=0.5;
		private var imgs:Array = [];
		private var enableNext:Boolean = false;
		
		
		public function ImageView(w:int,h:int,scaleMode:String=ScaleMode.PROPORTIONAL_OUTSIDE,screenCount:int=1,backgroundColor:uint=0x000000)
		{
			super(w,h);
			this.screenCount= screenCount;
			this.scaleMode = scaleMode;
			this._edgeHeight = h;
			this._edgeWidth =w;
			container = new Sprite();
			this.addChild(container);
			this.graphics.clear();
			//this.graphics.beginFill(backgroundColor);
			this.graphics.beginFill(0x00000);
			this.graphics.drawRect(0,0,this.edgeWidth,this.edgeHeight);
			this.graphics.endFill();
			container.addEventListener(MouseEvent.MOUSE_DOWN,onContainerMouseDownHandler);
            container.doubleClickEnabled = true;
			container.addEventListener(MouseEvent.DOUBLE_CLICK, onContainerDoubleClickHandler);

            left = BitmapUtil.getBitmapByClass(TurnLeft);
			right = BitmapUtil.getBitmapByClass(TurnRight);		
			
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler);
			
			this.addChild(left);
			this.addChild(right);
			
			left.y = (this.edgeHeight-left.height)/2;
			right.y = (this.edgeHeight-left.height)/2;
			
			left.x = 20;
			right.x = (this.edgeWidth-left.width)-20;		
			
		}
        private function onContainerDoubleClickHandler(event:MouseEvent):void {
            //trace(event.target.name,event.currentTarget.name);
			this.dispatchEvent(new OperationEvent(OperationEvent.OPERATION,event.target.name));
        }
		public function showTurnButton(va:Boolean):void{
			left.visible = va;
			right.visible = va;
		}
		private function onContainerMouseDownHandler(event:MouseEvent):void
		{



			// TODO Auto-generated method stub
			downPoint = new Point(container.mouseX,container.mouseY);
			point = new Point(this.mouseX,this.mouseY);
			container.addEventListener(MouseEvent.MOUSE_MOVE,onContainerMouseMoveHandler);
			container.addEventListener(MouseEvent.MOUSE_UP,onContainerMouseUpHandler);
			//container.addEventListener(MouseEvent.RELEASE_OUTSIDE,onContainerMouseUpHandler);
		}
		private var u:Number=0;
		private function onContainerMouseUpHandler(event:MouseEvent):void
		{
			container.removeEventListener(MouseEvent.MOUSE_MOVE,onContainerMouseMoveHandler);
			container.removeEventListener(MouseEvent.MOUSE_UP,onContainerMouseUpHandler);
			//container.removeEventListener(MouseEvent.RELEASE_OUTSIDE,onContainerMouseUpHandler);
			
			var moveLen:Number = container.x%(this.edgeWidth/screenCount);			
			
			//trace("movel:",point.x-this.mouseX);
			if(moveLen==0){
				//var u:Number = Math.abs(container.x/this.edgeWidth);
				//tweent = TweenLite.to(container,antTime,{x:-u*this.edgeWidth});				
				return;
			}
			
			//trace(int(container.x/this.edgeWidth));
			
			//return;
			if(container.x>=0){
			
				tweent = TweenLite.to(container,antTime,{x:0});
				
			}else if(container.x<-(container.width-this.edgeWidth/screenCount+this.edgeWidth/screenCount/10)){
				var ml:Number = (int(container.x/(this.edgeWidth/screenCount)))*(this.edgeWidth/screenCount);
				if(ml-(this.edgeWidth+this.edgeWidth/screenCount)<-((this.edgeWidth/screenCount*this.totalFrame))){
					//move_x = -container.width+this.edgeWidth;
					if(screenCount>1){
						//move_x = -(container.width-this.edgeWidth);
						//if(container.x<-(container.width-this.edgeWidth)){
						u = (this.totalFrame-1)-screenCount;
						ml = -u*(this.edgeWidth/screenCount);
						//trace("u",uu);
					}
					
				}
				tweent = TweenLite.to(container,antTime,{x:ml});	
			}else{				
				//tweent = TweenLite.to(container,0.3,{x:moveLen});
				//trace(container.width/container.x);				
				u = Math.abs(container.x/(this.edgeWidth/screenCount));
				
				//trace(edgeWidth/container.x);
				//trace(container.x<-(container.width-this.edgeWidth+this.edgeWidth/10))
				if(Math.abs(moveLen)>this.edgeWidth/screenCount/10){
					//trace(u,u%0.5,Math.floor(u));
					//u =Math.round(u);
					if(u%0.5>0.15){
						if(point.x-this.mouseX>0){
							u=Math.floor(u)+1;
						}else{
							//trace("u",u);
							
							/*if((point.x-this.mouseX)<0){
								if((1-u)>0.15){								
											
									u=Math.round(u)-1;
								}else{
									u=Math.floor(u);	
								}
							}else{
								u=Math.floor(u);
							}*/
							
							u=Math.floor(u);
							//u=Math.round(u);
							if(u<0){
								u=0;
							}
						}
						//trace(u);
						if(u>imgs.length-1){
							u= imgs.length-1;
						}
						redrowItemContent(imgs[u][0],imgs[u][1],u);						
						
					}else{
						u =Math.round(u);
						//trace(u+"----");
						redrowItemContent(imgs[u][0],imgs[u][1],u);	
					}
					
					
					//tweent = TweenLite.to(container,antTime,{x:-u*(this.edgeWidth/screenCount)});
					
					
				}else{
					u=Math.floor(u);
					//u=0;
					//tweent = TweenLite.to(container,antTime,{x:-u*(this.edgeWidth/screenCount)});				
				}
				//trace("u",u);
				var move_x:Number = -u*(this.edgeWidth/screenCount);
				//trace("move_x",move_x-(this.edgeWidth+this.edgeWidth/screenCount),-((this.edgeWidth/screenCount*this.totalFrame)));
				if(move_x-(this.edgeWidth+this.edgeWidth/screenCount)<-((this.edgeWidth/screenCount*this.totalFrame))){
					//move_x = -container.width+this.edgeWidth;
					if(screenCount>1){
						//move_x = -(container.width-this.edgeWidth);
						//if(container.x<-(container.width-this.edgeWidth)){
						u = (this.totalFrame-1)-screenCount;
						move_x = -u*(this.edgeWidth/screenCount);
						//trace("u",u);
					}
					
				}else{
				
				}
				
				tweent = TweenLite.to(container,antTime,{x:move_x});								
			}
			
			trace(u);
			index =u-10;
			if(index<0){
				index=0;
			}
			loadAll();
			
		}
		public function moveTo(x:Number):void{
            tweent = TweenLite.to(container,antTime,{x:x});
        }
		private function onContainerMouseMoveHandler(event:MouseEvent):void
		{
			//trace((container.width+container.x),this.edgeWidth-(this.edgeWidth/10));
			if(container.x<-(container.width-this.edgeWidth)){
				return;
			}
			
			if(container.x>0 && container.x>this.edgeWidth/screenCount/10){
				onContainerMouseUpHandler(null);
				return;
			}
			//trace("a",container.x);
			//trace("b",-container.width);
			if(container.x<-(container.width-this.edgeWidth+this.edgeWidth/10)){
			//if(container.x<-container.width+this.edgeWidth-(this.edgeWidth/screenCount)/10){
				onContainerMouseUpHandler(null);
				return;
			}
			container.x = mouseX-downPoint.x;		
			//trace(container.x);
		}
		public function rest():void{
			this.index = 0;			
			container.removeChildren();
			this.imgs.splice(0,imgs.length);
			container.x = 0;			
		}
		private var fileList:Array;
		public function setConfig(path:String,prefix:String="",startFileName:String="0000",format:String="jpg"):void{
			this.path = path;
			
			this.prefix = prefix;
			this.startFileName = startFileName;
			this.format = format;		
			
			fileList = File.applicationDirectory.resolvePath(path).getDirectoryListing();
			
			this.loadAll();
			
			this.alpha = 0;
			
			
			//totalFrame = File.applicationDirectory.resolvePath(path).getDirectoryListing().length;
			
			
			if(startFileName!=null){
				totalFrame = File.applicationDirectory.resolvePath(path).getDirectoryListing().length;
			}else{
				totalFrame = 1;
			}
			
			if(totalFrame==screenCount){
				this.showTurnButton(false);
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}else{
				this.showTurnButton(true);
				this.mouseChildren = true;
				this.mouseEnabled = true;
			}			
			
			TweenLite.to(this,1,{alpha:1});			
			
		}	
		
		public function enableMouseNext(valeu:Boolean):void{
			this.enableNext = valeu;
		}
		protected function redrowItemContent(itemContainer:Sprite,content:DisplayObject,index:int):void{
		
			
			
		}
		protected function itemContent(itemContainer:Sprite,content:DisplayObject,index:int):DisplayObject{
			
			var bd:BitmapData = new BitmapData(content.width,content.height,true,0x00000000);
			bd.draw(content,null,null,null,null,true);
			
			var bitmap:Bitmap = new Bitmap(bd,PixelSnapping.AUTO,true);			
			itemContainer.addChild(bitmap);				
			return bitmap;
			
			
		}
		
		private function onCompleteHandler(event:Event):void
		{
			var sp:Sprite;
			var dp:DisplayObject;
			
			var p:int = u-20;
			if(p>0){
				
				for(var i:int=p;i>=0;i--){
					var res:Array = imgs[i];
					trace(i);
					var zw:Sprite = new Sprite();
					zw.graphics.beginFill(0xffffff*Math.random(),1);
					zw.graphics.drawRect(0,0,this.edgeWidth/screenCount,this.edgeHeight);
					zw.graphics.endFill();
					var pp:DisplayObject = res[1];
					if(pp && pp.parent){
						
						pp.parent.removeChild(pp);
												
					}
					imgs[i]=[res[0],zw,false];					
					
				}
				
			}
			
			
			var arr:Array = imgs[index];
			if(arr!=null){
				sp = arr[0];
				dp = arr[1];
				
				
				var isloader:Boolean = arr[2];
				if(isloader==false){
					if(dp.parent){
						dp.parent.removeChild(dp);
					}	
					
					dp=itemContent(sp,load.content,index);
					
					area = new AutoFitArea(sp, 0, 0, edgeWidth/screenCount, edgeHeight, 0x000000);
					//area.attach(dp,{scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, crop:true});
					area.attach(dp,{scaleMode:this.scaleMode,crop:true});
					area.preview = true;
                    sp.name = String(index);
                    sp.mouseChildren = false;
					container.addChild(sp);				
					sp.x = this.edgeWidth/screenCount * index;
                    sp.doubleClickEnabled = true;
					imgs[index] = [sp,dp,true];
				}
				
				
			}else{
				sp = new Sprite();
				sp.graphics.beginFill(0x00000000,0);
				sp.graphics.drawRect(0,0,this.edgeWidth/screenCount,this.edgeHeight);
				sp.graphics.endFill();		
				
				
				var zw:Sprite = new Sprite();
				zw.graphics.beginFill(0xffffff*Math.random(),1);
				zw.graphics.drawRect(0,0,this.edgeWidth/screenCount,this.edgeHeight);
				zw.graphics.endFill();	
				
				if(index<100){
					dp = itemContent(sp,load.content,index);	
					imgs[index] = [sp,dp,true];
				}else{
					dp = itemContent(sp,zw,index);
					imgs[index] = [sp,dp,false];
				}
				
				
				area = new AutoFitArea(sp, 0, 0, edgeWidth/screenCount, edgeHeight, 0x000000);
				//area.attach(dp,{scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, crop:true});
				area.attach(dp,{scaleMode:this.scaleMode,crop:true});
				area.preview = true;
                sp.name = String(index);
                sp.mouseChildren = false;
                sp.doubleClickEnabled = true;
				container.addChild(sp);
				
				sp.x = this.edgeWidth/screenCount * index;
				
				
			}			
			if(index==0){
				this.redrowItemContent(sp,dp,index);
			}			
			index++;
			if(index>u+10){
				//return;
			}
			loadAll();
		}
		
		private function onErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		private function getPath(_index:int):String{
			
			if(startFileName!=null){
				var startIndex:int = startFileName.length-String(_index).length;
				if(startIndex<0){
					//throw new Error("超出索引范围");
					startIndex = 0;
				}
				//trace(startIndex);
				var FN:String = startFileName.substr(0,startIndex)+String(_index);
				
				
				return path+"/"+prefix+FN+"."+format;
			}else{
				return path+"/"+prefix+"."+format;
			}
			
			
		}
		private var fileStream:FileStream=new FileStream();
		private function loadAll():void{	
				
			
			if(prefix==null && startFileName==null && format==null){
				
				if(index<=fileList.length-1){
					
					var file:File = fileList[index];
					//trace(file.nativePath);
					fileStream.open(file,FileMode.READ);
					var ba:ByteArray = new ByteArray();
					fileStream.readBytes(ba);
					fileStream.close();
					load.loadBytes(ba);
					
				}				
				
			}else{
				var path:String = getPath(index);
				
				if(File.applicationDirectory.resolvePath(path).exists){
					
					
					load.load(new URLRequest(path));
					
					/*if(startFileName!=null){
						totalFrame = Math.max(totalFrame,index);
					}else{
						totalFrame = 1;
					}*/
					
					
					
				}
			}
		}


    }
}
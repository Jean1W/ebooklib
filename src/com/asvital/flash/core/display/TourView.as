package com.asvital.flash.core.display
{
	import flash.display.Loader;
	import flash.display.Shape;
import flash.display.StageDisplayState;
import flash.events.Event;
	import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.utils.Cast;

	public class TourView extends BaseDispaly
	{
		protected var view:View3D;
		protected var cameraController:HoverController;
		private var _source:Object;
		private var loader:Loader;
		private var torus:Mesh;
		private var isCopy:Boolean = false;



        private var move:Boolean = false;
        private var lastPanAngle:Number;
        private var lastTiltAngle:Number;
        private var lastMouseX:Number;
        private var lastMouseY:Number;
        private var mouseLockX:Number = 0;
        private var mouseLockY:Number = 0;
        private var mouseLocked:Boolean;

        private var mouseNavigation:Boolean;

		public function TourView(w:Number, h:Number,isCopy:Boolean=false,mouseNavigation:Boolean=false)
		{
			super(w, h);
			view = new View3D();				
			view.backgroundColor = 0x000000;	
			
			this.mouseNavigation = mouseNavigation;
			
			this.isCopy = isCopy;
			
			var sp:Shape = new Shape();
			sp.graphics.beginFill(Math.random()*0xffffff,0);
			sp.graphics.drawRect(0,0,w,h);
			sp.graphics.endFill();
			this.addChild(sp);
			this.addChild(view);
			
			
			//view.camera.z = -600;
			//view.camera.y = 0;
			//view.camera.z = -250;
			//trace(view.camera.z);
			//view.camera.lookAt(new Vector3D(0,0,-500));
			//view.camera.lens = new PerspectiveLens(90);
			
			
			cameraController = new HoverController(view.camera,null,180, 0,500,-20,20);
			
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);



			
		}
        private function onStageMouseLeave(event:Event):void
        {
            move = false;
            stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }
        private function onMouseDown(event:MouseEvent):void
        {
            lastPanAngle = cameraController.panAngle;
            lastTiltAngle = cameraController.tiltAngle;
            lastMouseX = stage.mouseX;
            lastMouseY = stage.mouseY;
            move = true;
            stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }

        /**
         * Mouse up listener for navigation
         */
        private function onMouseUp(e:MouseEvent):void
        {
            move = false;
            stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }

        /**
         * Mouse move listener for mouseLock
         */
        private function onMouseMove(e:MouseEvent):void
        {


                /*if (mouseLocked && (lastMouseX != 0 || lastMouseY != 0)) {
                    e.movementX += lastMouseX;
                    e.movementY += lastMouseY;
                    lastMouseX = 0;
                    lastMouseY = 0;
                }*/

                mouseLockX += e.movementX;
                mouseLockY += e.movementY;

                /*if (!stage.mouseLock) {
                    stage.mouseLock = true;
                    lastMouseX = stage.mouseX - stage.stageWidth/2;
                    lastMouseY = stage.mouseY - stage.stageHeight/2;
                } else*/ if (!mouseLocked) {
                    mouseLocked = true;
                }

                //ensure bounds for tiltAngle are not eceeded
                if (mouseLockY > cameraController.maxTiltAngle/0.3)
                    mouseLockY = cameraController.maxTiltAngle/0.3;
                else if (mouseLockY < cameraController.minTiltAngle/0.3)
                    mouseLockY = cameraController.minTiltAngle/0.3;

        }
		
		private function onCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(loader.content));
			textureMaterial.bothSides = true;
			textureMaterial.smooth = true;
			textureMaterial
			
			torus = new Mesh(new SphereGeometry(2000, 80, 50),textureMaterial);
			torus.scaleX = -1;
			view.scene.addChild(torus);
			
			view.render();
			
			
			
			
			addEventListener(Event.ENTER_FRAME,onRender);
			//view.visible = false;
		}
		
		override protected function initView():void
		{
			// TODO Auto Generated method stub
			super.initView();
			
			//stage.focus = this;
			
			if(isCopy==false){
				this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardHandler);
				this.addEventListener(KeyboardEvent.KEY_UP,onKeyboardHandler);
			}
			
			
			//view.render();
			
			view.width = this.edgeWidth;
			view.height =this.edgeHeight;


            if(mouseNavigation){

                stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

            }
			
			//stage.addEventListener(Event.RESIZE,onReSizeHandler);
			
		}
		[Deprecated]
		private function onReSizeHandler(w:Number,h:Number):void
		{
			//trace(this.parent.width);
			view.width = w;
			view.height =h;	
			if(this.torus){
				
				view.render();
			}
			
		}
		public function runRender():void{
			if(this.torus){
				
				view.render();
			}
		}
		private var isLeft:Boolean = false;
		private var isRight:Boolean = false;
		private var isTop:Boolean = false;
		private var isBottom:Boolean = false;
		
		protected function onKeyboardHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.type == KeyboardEvent.KEY_DOWN){
				if(event.keyCode==Keyboard.LEFT){
					isLeft = true;
				}
				if(event.keyCode==Keyboard.RIGHT){
					isRight = true;
				}
				if(event.keyCode==Keyboard.UP){
					isTop = true;
				}
				if(event.keyCode==Keyboard.DOWN){
					isBottom = true;
				}
				//this.addEventListener(Event.ENTER_FRAME,onMoveHandler);
			}else{
				//this.removeEventListener(Event.ENTER_FRAME,onMoveHandler);
				
				if(event.keyCode==Keyboard.LEFT){
					isLeft = false;
				}
				if(event.keyCode==Keyboard.RIGHT){
					isRight = false;
				}
				if(event.keyCode==Keyboard.UP){
					isTop = false;
				}
				if(event.keyCode==Keyboard.DOWN){
					isBottom = false;
				}				
			}	
			
			
			if(isLeft){
				cameraController.panAngle -= 1;
			}else if(isRight){
				cameraController.panAngle += 1;
			}
			
			if(isTop){
				cameraController.tiltAngle -= 1;
			}else if(isBottom){
				cameraController.tiltAngle += 1;
			}
			
			view.render();
			
			
		}		
		public function stop():void{
			removeEventListener(Event.ENTER_FRAME, onRender);
			
			trace(stage);
			
			view.visible = false;
			
		}
		public function run():void{
			//addEventListener(Event.ENTER_FRAME, onRender);
			if(stage){
				view.visible = true;
			}
		}
		//private var _stop:Boolean = false;
		public function getAngle():Point{
			return new Point(cameraController.panAngle,cameraController.tiltAngle);
		}
		public function setAngle(angle:Point):void{
			cameraController.panAngle = angle.x;
			cameraController.tiltAngle = angle.y;
			view.render();
		}
		protected function onRender(event:Event):void
		{
			//torus.rotationY += 0.2;


            if (move) {
                cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
                cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
            }

            view.render();


			
			if(torus==null){
				return;
			}
			
			
			
			if(isLeft==false && isRight==false && isTop==false && isBottom==false){
				//torus.rotationY += 0.2;	
			}
			
			//trace(cameraController.tiltAngle);
			
			
			//cameraController.panAngle += 0.3*2;
			//cameraController.tiltAngle += 0.3*2;
			
			/*if (stage.mouseLock) {
				cameraController.panAngle = 0.3*mouseLockX;
				cameraController.tiltAngle = 0.3*mouseLockY;
			} else if (move) {
				cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}*/
			
			
			
			
			
			
		}
		
		public function get source():Object
		{
			return _source;
		}

		public function set source(value:Object):void
		{
			_source = value;
			while(view.scene.numChildren>0){
				view.scene.removeChildAt(0);
			}
			loader.load(new URLRequest(String(_source)));
			trace(_source);
		}

	}
}
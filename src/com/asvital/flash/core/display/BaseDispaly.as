package com.asvital.flash.core.display
{
	import com.asvital.flash.core.manager.IFocusManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseDispaly extends Sprite implements IFocusManager
	{
		private var _frameRate:int = 25;
		private var _edgeWidth:Number =0;
		private var _edgeHeight:Number= 0;
		private var _enabled:Boolean= true;
		private var _focusManager:IFocusManager;
		
		private var _toper:Sprite;
		private var _middler:Sprite;
		private var _bottomer:Sprite;
		
		public function BaseDispaly(w:Number,h:Number)
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHanlder);
			this._edgeWidth = w;
			this._edgeHeight = h;
			this.addEventListener(Event.ADDED_TO_STAGE,addStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,reomveStageHandler);
			this.focusRect = false;
			this.tabEnabled = true;
			//this.cacheAsBitmap = true;		
			
			
			_toper =new Sprite();
			_middler =new Sprite();
			_bottomer =new Sprite();
			
			super.addChild(_bottomer);
			super.addChild(_middler);
			super.addChild(_toper);
		}
		
		public function get bottomer():Sprite
		{
			return _bottomer;
		}

		public function get middler():Sprite
		{
			return _middler;
		}

		public function get toper():Sprite
		{
			return _toper;
		}

		public function get focusBorder():Boolean
		{
			// TODO Auto Generated method stub
			return focusManager.focusBorder;
		}
		
		public function set focusBorder(value:Boolean):void
		{
			// TODO Auto Generated method stub
			//focusManager.focusBorder(value);
			focusManager.focusBorder =value;
		}
		
		
		public function get focusManager():IFocusManager
		{
			if(_focusManager){
				return _focusManager;
			}
			var o:DisplayObject = this.parent;
			while(o){
				if((o as BaseDispaly)==null){
					o = o.parent;
					continue;
				}else{
				  if(BaseDispaly(o).focusManager==null){
					  o = o.parent;
					  continue;
				  }else{
				  	_focusManager = BaseDispaly(o).focusManager;
					break;
				  }
				}
			}
			return _focusManager;
		}

		public function set focusManager(value:IFocusManager):void
		{
			_focusManager = value;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		protected function addStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function reomveStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		public function get edgeHeight():Number
		{
			return _edgeHeight;
		}
		
		public function get edgeWidth():Number
		{
			return _edgeWidth;
		}
		
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		public function set frameRate(value:int):void
		{
			_frameRate = value;
		}
		
		private function onStageHanlder(event:Event):void
		{
			frameRate=stage.frameRate;
			this.removeEventListener(Event.ADDED_TO_STAGE,onStageHanlder);
			// TODO Auto-generated method stub
			initView();
			
		}
		protected function initView():void{
			
		}
		
		public function activate():void
		{
			// TODO Auto Generated method stub
			focusManager.activate();
		}
		
		public function deactivate():void
		{
			// TODO Auto Generated method stub
			focusManager.deactivate();
		}
		
		public function get defaultButton():Button
		{
			// TODO Auto Generated method stub
			return focusManager.defaultButton;
		}
		
		public function set defaultButton(value:Button):void
		{
			// TODO Auto Generated method stub
			focusManager.defaultButton = value;
		}
		
		public function get defaultButtonEnabled():Boolean
		{
			// TODO Auto Generated method stub
			return focusManager.defaultButtonEnabled;
		}
		
		public function set defaultButtonEnabled(value:Boolean):void
		{
			// TODO Auto Generated method stub
			focusManager.defaultButtonEnabled = value;
		}
		
		public function findFocusManagerComponent(component:InteractiveObject):InteractiveObject
		{
			// TODO Auto Generated method stub
			return focusManager.findFocusManagerComponent(component);
		}
		
		public function get form():DisplayObjectContainer
		{
			// TODO Auto Generated method stub
			return focusManager.form;
		}
		
		public function set form(value:DisplayObjectContainer):void
		{
			// TODO Auto Generated method stub
			focusManager.form = value;
		}
		
		public function getFocus():InteractiveObject
		{
			// TODO Auto Generated method stub
			return focusManager.getFocus();
		}
		
		public function getNextFocusManagerComponent(backward:Boolean=false):InteractiveObject
		{
			// TODO Auto Generated method stub
			return focusManager.getNextFocusManagerComponent(backward);
		}
		
		public function hideFocus():void
		{
			// TODO Auto Generated method stub
			focusManager.hideFocus();
		}
		
		public function get nextTabIndex():int
		{
			// TODO Auto Generated method stub
			return focusManager.nextTabIndex;
		}
		
		public function setFocus(o:InteractiveObject):void
		{
			// TODO Auto Generated method stub
			focusManager.setFocus(o);
		}
		
		public function showFocus():void
		{
			// TODO Auto Generated method stub
			focusManager.showFocus();
		}
		
		public function get showFocusIndicator():Boolean
		{
			// TODO Auto Generated method stub
			return focusManager.showFocusIndicator;
		}
		
		public function set showFocusIndicator(value:Boolean):void
		{
			// TODO Auto Generated method stub
			focusManager.showFocusIndicator = value;
		}
		
	}
}
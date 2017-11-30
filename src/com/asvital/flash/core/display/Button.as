package com.asvital.flash.core.display
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class Button extends SimpleButton
	{
		private var _emphasized:Boolean = false;
		public function Button(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}

		public function get emphasized():Boolean
		{
			return _emphasized;
		}

		public function set emphasized(value:Boolean):void
		{
			_emphasized = value;
		}

	}
}
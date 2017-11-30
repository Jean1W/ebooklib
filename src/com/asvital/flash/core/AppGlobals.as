package com.asvital.flash.core
{
	import com.asvital.flash.core.display.Application;

	public class AppGlobals
	{
		public static var topLevelApplication:Application;
		
		private static var _isAir:Boolean = true;
		
		public function AppGlobals()
		{
		}

		public static function get isAir():Boolean
		{
			return _isAir;
		}

		public static function set isAir(value:Boolean):void
		{
			_isAir = value;
		}

	}
}
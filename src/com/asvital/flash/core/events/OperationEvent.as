package com.asvital.flash.core.events
{
	import flash.events.Event;
	
	public class OperationEvent extends Event
	{
		public static const OPERATION:String="operation";
		public static const HIDE:String="hide";
		public static const SHOW:String="show";
		public static const EXIT:String = "exit";
		public static const COMPLETE:String="complete"
		
		private var _data:Object;
		
		public function OperationEvent(type:String,_data:Object=null)
		{
			super(type);
			this._data = _data;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}
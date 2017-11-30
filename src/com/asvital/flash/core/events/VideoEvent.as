package com.asvital.flash.core.events
{
	import flash.events.Event;
	
	public class VideoEvent extends Event
	{
		public static const OVER:String = "over";
		public static const READY:String ="ready";
		public static const SEEK_OVER:String ="seek_over";
		public static const CUE_POINT:String ="cue_point";		
		public function VideoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
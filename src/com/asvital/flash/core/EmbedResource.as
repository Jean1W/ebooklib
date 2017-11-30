package com.asvital.flash.core
{
	public class EmbedResource
	{
		[Embed(source="../../../../close_up.png")]
		public static var CloseUp:Class;
		[Embed(source="../../../../close_down.png")]
		public static var CloseDown:Class;
		
		
		[Embed(source="../../../../box_close_up.png")]
		public static var boxCloseUp:Class;
		[Embed(source="../../../../box_close_down.png")]
		public static var boxCloseDown:Class;
		
		
		
		[Embed(source="../../../../mask.png",mimeType="image/png")]
		public static var LogoMask:Class;
		
		public function EmbedResource()
		{
			
		}
	}
}
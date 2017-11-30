package com.asvital.flash.core.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;

	public class BitmapUtil
	{
		public function BitmapUtil()
		{
			
		}
		public static function getBitmapByClass(Cla:Class):Bitmap{
			
			var bm:Bitmap = new Cla();
			var bitdata:BitmapData = new BitmapData(bm.width,bm.height,true,0x000000);
			bitdata.draw(bm,null,null,null,null,true);
			
			var obj:Bitmap = new Bitmap(bitdata,PixelSnapping.AUTO,true);
			obj.smoothing = true;
			return obj;
			
		}
		public static function getBitmapByDisplay(dis:DisplayObject):Bitmap{
		
			var bitdata:BitmapData = new BitmapData(dis.width,dis.height,true,0x000000);
			bitdata.draw(dis,null,null,null,null,true);
			
			var obj:Bitmap = new Bitmap(bitdata,PixelSnapping.AUTO,true);
			obj.smoothing = true;
			return obj;
		
		}
		public static function getBitmapByClassScale(Cla:Class,scale:Number):Bitmap{
			
			var bm:Bitmap = new Cla();
			//bm.scaleX = bm.scaleY = scale;
			var bitdata:BitmapData = new BitmapData(bm.width*scale,bm.height*scale,true,0x000000);
			var matrix:Matrix=new Matrix();
			matrix.a=scale;
			matrix.d =scale;
			bitdata.draw(bm,matrix,null,null,null,true);
			
			var obj:Bitmap = new Bitmap(bitdata,PixelSnapping.AUTO,true);
			obj.smoothing = true;
			return obj;
			
		}
	}
}
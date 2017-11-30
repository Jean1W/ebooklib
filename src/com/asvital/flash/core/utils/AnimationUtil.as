package com.asvital.flash.core.utils
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.InteractiveObject;

	public class AnimationUtil
	{
		public function AnimationUtil()
		{
		}
		public static function pushOut(show:InteractiveObject,hide:InteractiveObject):void{
			show.alpha = 0;
			show.z = -850;
			TweenMax.to(hide,0.5,{z:3600,alpha:0,ease:Cubic.easeOut,onComplete:function():void{
				if(hide.parent){
					hide.parent.removeChild(hide);
				}				
				hide.alpha = 1;
			}});
			TweenMax.to(show,1,{z:0,alpha:1,ease:Cubic.easeIn});
		}
		public static function pushIn(show:InteractiveObject,hide:InteractiveObject):void{
			
			show.alpha = 0;
			show.z = 1550;
			TweenMax.to(show,1,{z:0,alpha:1,ease:Cubic.easeIn});
			TweenMax.to(hide,0.5,{z:-850,alpha:0,ease:Cubic.easeOut,onComplete:function():void{
				if(hide.parent){
					hide.parent.removeChild(hide);
				}
				hide.alpha = 1;
			}});
		}
	}
}
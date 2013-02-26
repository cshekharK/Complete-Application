package com.application.util
{
	import com.greensock.loading.SWFLoader
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class SWFLoaderUtil extends SWFLoader  
	{
		public function SWFLoaderUtil(_url:String,_x:Number,_y:Number)
		{
			
			super(_url, {name:"screen1", container:this., x:0, y:0, autoPlay:true, estimatedBytes:9500, onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
	
		}
		
		private function progressHandler(event:LoaderEvent):void
		{
			trace("laoding...")
			//preLoader.bar_mc.scaleX = event.target.progress;
		//	this.addChild(preLoader);

		//	var sm:StageManager = new StageManager(stage,"easing",.2,Regular.easeOut);
			//sm.addItem(preLoader, "MC");
		//	sm.init();
		//	sm.addEventListener(StageManagerEvent.ON_RESIZE, resizeHandler);

		}
		
		private function completeHandler(event:LoaderEvent):void
		{
			trace(SWFLoader(event.target).rawContent)
			
			TweenLite.from(event.target.content, 1, { alpha:1 } );
			//SWFLoader(event.target).rawContent.play();
			//this.removeChild(preLoader);
			//if (isLoadedScreen1 == false)
			//{
				//isLoadedScreen1 = true;
				//swf = swfLoader.rawContent;
				//swf.addEventListener(CustomEvent.SCREEN1_END, onScreen1End);
			//}
		}
		
		private function errorHandler(event:LoaderEvent):void
		{
			trace("error occured with " + event.target + ": " + event.text);
		}
		
	}
	
}
package preloader
{
	import mx.preloaders.*; 
	import flash.events.ProgressEvent;
	import mx.preloaders.DownloadProgressBar;
	import flash.text.*;
	public class CustomSparkDownloadProgressBar extends DownloadProgressBar
	{
		
		public function CustomSparkDownloadProgressBar() {   
			
			super();
			
			
		}
		// Override to return true so progress bar appears
		// during initialization.       
		override protected function showDisplayForInit(elapsedTime:int,count:int):Boolean {
			super.initialize();
			
			
			center(stageWidth, (stageHeight > 550) ? 550 : stageHeight);    
			return true;
		}
		
		// Override to return true so progress bar appears during download.     
		override protected function showDisplayForDownloading(
			elapsedTime:int, event:ProgressEvent):Boolean {
			
			return true;
		}
	}
}
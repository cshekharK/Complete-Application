/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:11 August 2012
* Last Updated Date: 30 August 2012
* 
*/
package com.application.controller{


	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import com.application.model5.ModelLocator5;
	import com.application.loaders.LoadLocalTXT;
	import com.application.util.StringUtilities;
	import flash.events.EventDispatcher;

	public class LoadTextController extends EventDispatcher {
		private var _model:ModelLocator5;
		private var _loader:URLLoader = new URLLoader;
		
		
		/**
		 * LoadTextController Constructor.
		 * Type:Public Function
		 * @param ModelLocator.
		 * @return none
		 */
		public function LoadTextController(m:ModelLocator5) {

			_model=m;
		
		}
		
		/**
		 * Load Text Command Function.
		 * Type:Public Mathod;
		 * @param none
		 * @return none
		 */
		public function load():void {

			var loadText:LoadLocalTXT = new LoadLocalTXT();
			loadText.addEventListener("Data_Loaded", loadComplete);
		}

		/**
		 * Text Load complete handler
		 * Type:private function event handler;
		 * @param none
		 * @return none
		 */
		private function loadComplete(e:Event):void {
			
			var fileContentText:String = e.target.data;
			fileContentText = StringUtilities.trimWhitespace(fileContentText);
			if (fileContentText.length!=0)
			{
				_model.text = fileContentText;
			}
			else
			{
				
				dispatchEvent(new Event("TextError"));			
				
			}
		}
		
	}
}
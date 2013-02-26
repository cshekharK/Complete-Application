/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:6 August 2012
* Last Updated Date: 25 August 2012
* 
*/
package com.application.view{

	
	import flash.display.MovieClip;
	import flash.events.*;
	import com.application.models.ModelLocator;
	import com.application.controller.LoadTextController;
	import com.application.view.ApplicationView;
	import flash.display.Stage;
	
	
	public class Main extends MovieClip 
	{
		private var _model:ModelLocator;
		private var _controller:LoadTextController;
		private var _view:ApplicationView;
		
		public static  var stage:Stage;
		public static  var _root:Object;
		
		/**
		 * Main Constructor. 
		 * Type:Private Function
		 * @param none
		 * @return none
		 */
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			_root =this;
		}
		
		/**
		 * Add View Component on initial stage.
		 * Type:Private Function
		 * @param event
		 * @return none
		 */
		private function init(evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_model = ModelLocator.getInstance();
			_controller=new LoadTextController(_model);
			_view = new ApplicationView(_model, _controller);
			addChild(_view);
		}
		
	}		
}
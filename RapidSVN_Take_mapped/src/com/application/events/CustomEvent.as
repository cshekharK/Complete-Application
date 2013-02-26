/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:5 August 2012
* Last Updated Date: 6 August 2012
* 
*/

package com.application.events{
	import flash.events.Event;

	public class CustomEvent extends Event {

		public static  const SCREEN1_END:String="SCREEN1_END";
		public static const TOGGLE_PAUSE:String = "Toggle_Pause"
		public static const XML_LOADED:String = "xmlLoaded"
		public static const CATEGORY_CLICK:String="category_click"
		public var data:*;

		public function CustomEvent(type:String,data:*) {
			type=type;
			this.data=data;
			super(type);
		}
		override public function clone():Event {
			return new CustomEvent(type,data);
		}
	}
}
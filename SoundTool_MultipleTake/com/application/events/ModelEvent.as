/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:16 August 2012
* Last Updated Date: 28 August 2012
* 
*/

package com.application.events{
	import flash.events.Event;

	public class ModelEvent extends Event {

		public static  const UPDATE:String="UPDATE";
		public static  const RECORD_SOUND:String="RECORD_SOUND";//added by oscar 10/01/13
		public static  const SHOW_SOUND:String = "SHOW_SOUND";//added by oscar 10/01/13
		
		public static  const NEW_PARAGRAPH_SELECTED:String = "NEW_PARAGRAPH_SELECTED";//added by oscar 06/02/13 USED POSSIBLE TO CLEAN TOOLS
		
		public static  const NO_PARAGRAPH_SELECTED:String="NO_PARAGRAPH_SELECTED";//added by oscar 06/02/13 USED POSSIBLE TO SHOW MESSAGE
		public static  const NO_AUDIO_ON_SERVER:String = "NO_AUDIO_ON_SERVER";//added by oscar 07/02/13 USED POSSIBLE TO SHOW MESSAGE
		
		public static  const REMOVE_WAVE_SELECTED:String="REMOVE_WAVE_SELECTED";//added by oscar 11/02/13 EDIT CURRENT AUDIO
		public static  const ADD_WAVE_SELECTED:String = "ADD_WAVE_SELECTED";//added by oscar 12/02/13 EDIT CURRENT AUDIO
		
		public static  const SHOW_AUDIO_LIST:String="SHOW_AUDIO_LIST";//added by oscar 15/02/13
		public static  const AUDIO_LIST_SELECTED:String="AUDIO_LIST_SELECTED";//added by oscar 15/02/13
		//public static  const HIDE_AUDIO_LIST:String="HIDE_AUDIO_LIST";//added by oscar 15/02/13 use NEW_PARAGRAPH_SELECTED instead to hide list
		
		
		public var data:*;
		public var mytype:String = "";
		
		public function ModelEvent(__type:String,data:*) {
			mytype=__type;
			this.data=data;
			super(mytype);
		}
		override public function clone():Event {
			return new CustomEvent(mytype,data);
		}
	}
}
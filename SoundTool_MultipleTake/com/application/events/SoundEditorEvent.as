/**
* ...
* @author Rapidsoftsys
* Started Date:21 August 2012
* Last Updated Date: 27 August 2012
* 
*/
package com.application.events{
	import flash.events.Event;

	public class SoundEditorEvent extends Event 
	{

		public static  const Sound_Error:String = "Sound_Error";
		public var data:*;

		public function SoundEditorEvent(type:String,data:*) {
			type=type;
			this.data=data;
			super(type);
			
		}
		override public function clone():Event {
			return new CustomEvent(type,data);
		}
	}
}
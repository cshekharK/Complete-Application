/**
* ...
* @author Rapidsoftsys
* Started Date:7 August 2012
* Last Updated Date: 22 August 2012
* 
*/

package com.application.events{
	import flash.events.Event;

	public class CustomSliderEvent extends Event
	{

		public static  const ON_CHANGE:String = "ON_CHANGE";
		public var data:*;

		public function CustomSliderEvent(type:String,data:*)
		{
			type=type;
			this.data=data;
			super(type);
			
		}
		override public function clone():Event {
			return new CustomEvent(type,data);
		}
	}
}
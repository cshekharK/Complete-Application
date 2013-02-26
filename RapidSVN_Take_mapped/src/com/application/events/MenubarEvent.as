/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:7 August 2012
* Last Updated Date: 22 August 2012
* 
*/

package com.application.events{
	import flash.events.Event;

	public class MenubarEvent extends Event
	{

		public static  const MENU_ITEM_CLICK:String = "menu_item_click";
		public var id:*;

		public function MenubarEvent(type:String,id:*)
		{
			type=type;
			this.id=id;
			super(type);
			
		}
		override public function clone():Event {
			return new CustomEvent(type,id);
		}
	}
}
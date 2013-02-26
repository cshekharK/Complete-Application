/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:21 August 2012
* Last Updated Date: 27 August 2012
* 
*/
package com.application.events{
	import flash.events.Event;

	public class TreeEvent extends Event 
	{

		public static  const NODE_CLICK:String = "node_click";
		public var id:*;

		public function TreeEvent(type:String,id:*) {
			type=type;
			this.id=id;
			super(type);
			
		}
		override public function clone():Event {
			return new CustomEvent(type,id);
		}
	}
}
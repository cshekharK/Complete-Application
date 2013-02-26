/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:5 August 2012
* Last Updated Date: 28 August 2012
* 
*/

package com.application.model5 {
	import com.application.events.ModelEvent;
	import flash.events.EventDispatcher;
	

	public class ModelLocator5 extends EventDispatcher {
		private static var instance:ModelLocator5=null;
		
		public var xml_data:XML;
		private var _text:String = '';
		public  var menus:XML = 
		<menus>
		<menu label="File">
		<menuitem label="Create From Text"  group="File" id="LoadTXT" />
		<menuitem label="Create From Pdf"  group="File" id="LoadPDF" />
		</menu>
		
		<menu label="Edit">
		<menuitem label="Add Paragraph" group="Edit" id="AddParagraph"/>
		<menuitem label="Remove Paragraph" group="Edit" id="RemoveParagraph" />
		<menuitem label="Edit Paragraph" group="Edit" id="EditParagraph" />
		
		</menu>
		
		<menu label="View">
		<menuitem label="View1" group="View" enabled="false"/>
		</menu>
		
		<menu label="Tools">
		<menuitem label="Tools1" group="Tools" enabled="false"/>
		</menu>
		
		<menu label="Audio">
		<menuitem label="Record Sound" group="Audio"/>
		<menuitem label="Import Audio" group="Audio"/>
		
		</menu>
		
		<menu label="Help">
		<menuitem label=" Help" group="Help"/>
		</menu>
		</menus>;

		/**
		 * function to check ModelLocator instence is available or not.
		 * Type:Public Function.
		 * @param none
		 * @return none
		 */
		public function ModelLocator5(enforcer:SingletonEnforcer) {
			super();
			if (enforcer==null) {
				throw new Error("You can only have one ModelLocator");
			}
		}
		
		/**
		 * function to get ModelLocator instence.
		 * Type:Public Function.
		 * @param none
		 * @return ModelLocator
		 */
		public static function getInstance():ModelLocator5 {
			if (instance==null) {
				instance=new ModelLocator5(new SingletonEnforcer() );
			}
			return instance;
		}
		
		/**
		 * Public Property text to get text file text content.
		 * Type:Public Function.
		 * @param none
		 * @return string.
		 */		
		public function get text():String{
			return _text;
			
			
		}
		
		/**
		 * Public Property text to set text file text content.
		 * Type:Public Function.
		 * @param string
		 * @return none.
		 */	
		public function set text(s:String):void{
			_text=s;
			dispatchEvent(new ModelEvent(ModelEvent.UPDATE,_text));
			
		}
		
		
	}
}
class SingletonEnforcer {
}
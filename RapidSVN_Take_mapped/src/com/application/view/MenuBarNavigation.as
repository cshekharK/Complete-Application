/**
* ...
* @author Rapidsoftsys
* Started Date:7 August 2012
* Last Updated Date: 8 Sept. 2012
* 
*/
package com.application.view{
	import com.application.events.*;
	import com.yahoo.astra.fl.controls.*;
	import com.yahoo.astra.fl.data.XMLDataProvider;
	import com.yahoo.astra.fl.events.MenuEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import mx.controls.Alert;

	public class MenuBarNavigation extends MovieClip {
		private var menuBar:MenuBar;
		private var menus:XML;
		
		/**
		 * MenuBarNavigation constructor.
		 * Type:Private Function .
		 * @param XML
		 * @return none
		 */
		public function MenuBarNavigation(menus:XML) {
			addEventListener(Event.ADDED_TO_STAGE,init);
			this.menus = menus;
		}
		
		/**
		 * function to initalize menu item .
		 * Type:Private Function Event Handler.
		 * @param event
		 * @return none
		 */
		private function init(evt:Event) {
			menuBar = new MenuBar(this);
			menuBar.dataProvider = new XMLDataProvider(menus);
			menuBar.width = 2000;
			menuBar.x = 7;
			menuBar.y = 80;
			menuBar.height = 53;
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, onMenuItemClickHandler);

			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.font = "Verdana";
			myTextFormat.size = 15;
			myTextFormat.color = 0xffffff
			
			var myTextFormatMenuItem:TextFormat = new TextFormat();
			myTextFormatMenuItem.font = "Verdana";
			myTextFormatMenuItem.size = 12;
			myTextFormatMenuItem.color = 0xffffff
			
			menuBar.setMenuBarRendererStyle("textFormat", myTextFormat);
			menuBar.setMenuRendererStyle("textFormat", myTextFormatMenuItem);
			menuBar.setMenuBarRendererStyle("menuLeftMargin ",20);
		}
		
		/**
		 * function to handle menu itme click event.
		 * Type:Private Function Event Handler.
		 * @param event
		 * @return none
		 */
		private function onMenuItemClickHandler(evt:MenuEvent) {
			var id = evt.label;
			dispatchEvent(new MenubarEvent(MenubarEvent.MENU_ITEM_CLICK,id));
		}



	}

}
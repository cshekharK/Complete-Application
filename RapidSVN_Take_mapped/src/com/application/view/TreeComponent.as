/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:6 August 2012
* Last Updated Date: 10 Sept. 2012
* 
*/
package com.application.view
{
	
	import flash.display.MovieClip;
	import fl.events.ListEvent;
	import com.application.events.TreeEvent;
	import flash.text.TextFormat;

	
	public class TreeComponent extends MovieClip
	{
		private var _dataProvider:Object
		
		
		/**
		 * TreeComponent class constructor
		 * Type:Private Function.
		 * @param none
		 * @return none
		 */
		public function TreeComponent()
		{
			mytree.addEventListener(ListEvent.ITEM_CLICK, handleClick);
			var myTextFormat:TextFormat = new TextFormat();
				myTextFormat.font = "Verdana";
				myTextFormat.size=11;
				mytree.setRendererStyle("textFormat", myTextFormat);
			
		}
		
		/**
		 * function to update tree element values.
		 * Type:Private Function.
		 * @param object
		 * @return none
		 */
		private function update(dataXml:Object):void 
		{
			mytree.dataProvider = new TreeDataProvider(dataXml);
			mytree.openAllNodes();
		}
		
		/**
		 * function to focus selected paragraph node in tree component.
		 * Type:Private Function.
		 * @param String
		 * @return none
		 */
		private function ShowSelectedParagrahNode(id:String):void {
			var foundNode:TNode = mytree.findNode("id",id);
			var nodeIndex:int = mytree.showNode(foundNode);
			mytree.selectedIndex = nodeIndex;
			mytree.scrollToSelected();
		}
		
		
		/**
		 * function to focus selected paragraph node in tree component.
		 * Type:Private Function Event Handler.
		 * @param object
		 * @return none
		 */
		private function handleClick(ev:ListEvent)
		{

			var id:Number = Number(ev.item.id);
			dispatchEvent(new TreeEvent(TreeEvent.NODE_CLICK,id));
		}
		
		
		/**
		 * Public property to get dataProvier of tree component.
		 * Type:Public Function.
		 * @param none
		 * @return Object
		 */
		public function get dataProvider():Object 
		{
			return _dataProvider;
		}
		
		
		/**
		 * Public property to set dataProvier of tree component.
		 * Type:Public Function.
		 * @param Object
		 * @return none
		 */
		public function set dataProvider(value:Object):void 
		{
			_dataProvider = value;
			update(_dataProvider)
		}
		
		/**
		 * function to find and select tree node.
		 * Type:Public Function.
		 * @param String
		 * @return none
		 */
		public function selectNode(id:String)
		{
			var foundNode:TNode = mytree.findNode("id",id);
			var nodeIndex:int = mytree.showNode(foundNode);
			mytree.selectedIndex = nodeIndex;
			mytree.scrollToSelected();
		}
		
	}
}
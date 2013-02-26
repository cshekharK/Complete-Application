/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:1 Sept. 2012
* Last Updated Date: 10 Sept. 2012
* 
*/

package com.application.view
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.container.ContainerController;
	
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.LinkElement;

	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.VerticalAlign;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ImageSpen 
	{
		private var smile:Smile=new Smile();
		private var linksArray = [];
		private var _textFlow:TextFlow;
		
		public function ImageSpen()
		{
				
		}
	
		public function insertImageInTextFlow(textFlow:TextFlow,paragraphIndex:Number)
		{
			
			textFlow.linkNormalFormat = { color:0xFF0000, textDecoration:TextDecoration.NONE };
			textFlow.verticalAlign=VerticalAlign.BOTTOM
			var inlineGraphicElement:InlineGraphicElement = new InlineGraphicElement();
			    inlineGraphicElement.source = drwCircle();
				inlineGraphicElement.verticalAlign= VerticalAlign.BOTTOM;
			var linkElement:LinkElement=new LinkElement();
				linkElement.id = String(paragraphIndex);
				linkElement.href = "event:linkSelect";
				linkElement.verticalAlign=VerticalAlign.BOTTOM;
				linkElement.addChild(inlineGraphicElement);
			
				 ParagraphElement(textFlow.getChildAt(paragraphIndex)).addChildAt(ParagraphElement(textFlow.getChildAt(paragraphIndex)).numChildren,linkElement)
					textFlow.addEventListener("linkSelect",linkSelect);
				_textFlow = textFlow;
				//findLinkElement(_textFlow);
			
		}
		private function drwCircle():Sprite {
			var yellowCircle:Sprite = new Sprite();
			var bitmap:Bitmap = new Bitmap(smile);
			yellowCircle.addChild(bitmap);
			return yellowCircle;
		}

		private function findLinkElement(group:FlowGroupElement):void {
			var childGroups:Array = [];
			for (var i:int = 0; i < group.numChildren; i++) {
				var element:FlowElement = group.getChildAt(i);
				if (element is LinkElement) {
					linksArray.push(element as LinkElement);
				}
				else if (element is FlowGroupElement) {
					childGroups.push(element);
				}
			}
			// Recursively check the child FlowGroupElements now
			for (i = 0; i < childGroups.length; i++) {
				var childGroup:FlowGroupElement = childGroups[i];
				findLinkElement(childGroup);
			}
			
			for (var j = 0; j<linksArray.length; j++) {
			linksArray[j].addEventListener(FlowElementMouseEvent.MOUSE_DOWN,linkSelect,false);
			}

		}

		private function linkSelect(evt:FlowElementMouseEvent) {
			trace("click",evt.flowElement.id);
		}
		
		public function get textFlow():TextFlow 
		{
			return _textFlow;
		}
		
		public function set textFlow(value:TextFlow):void 
		{
			_textFlow = value;
		}
		
		
	}
	
}
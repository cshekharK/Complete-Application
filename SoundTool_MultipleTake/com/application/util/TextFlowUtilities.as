	/**
	 * ...
	 * @author Rapidsoftsys
	 */
package com.application.util
{
	import flashx.textLayout.conversion.TextConverter;
    import flashx.textLayout.container.ContainerController;
    import flashx.textLayout.elements.ParagraphElement;
    import flashx.textLayout.elements.SpanElement;
    import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.*;
	import com.application.view.ImageSpen;
	
	public class TextFlowUtilities 
	{
		
		public static function removeAllParagraph(textFlow:TextFlow):TextFlow
		{
			 textFlow.replaceChildren(0, textFlow.numChildren);
			 return textFlow;
		}
		
		public static function setParagraphProperty(textFlow:TextFlow, paragraphIndex:int, propertyName:*, value:String):TextFlow
		{
			
			var paragraphs:Array = textFlow.mxmlChildren; 
			var numParagraphs:int = paragraphs.length;
			paragraphs[paragraphIndex].color="0xCC3300"
			if(propertyName=="id")
			{
				paragraphs[paragraphIndex].id=value
			}
			else if (propertyName == "typeName")
			{
				paragraphs[paragraphIndex].typeName=value
			}
			
			textFlow.replaceChildren(0, textFlow.numChildren);
			
			 for (var i:int=0; i<numParagraphs; i++)
			 {         		
				textFlow.addChild(paragraphs[i])
			
			 }
			
			 return textFlow;
			
		}
		
		public static function removeParagraph(textFlow:TextFlow, index:int):TextFlow
		{
			textFlow.removeChildAt(index);
			return textFlow;
		}
		
		
		public static function addParagraph(textFlow:TextFlow, index:int):TextFlow
		{
			var paragraphs:Vector.<ParagraphElement> = getParagraphElements("Click here and edit paragraph ");
			for (var i:uint = 0; i < paragraphs.length; i++)
			{
				textFlow.addChildAt(index + 1, paragraphs[i]);
			}
			return textFlow;
		}
		
		public static function traceTextFlow(textFlow:TextFlow)
		{
			var _text:String = TextConverter.export(textFlow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE) as String;
			trace(_text);
		}
		
		public static function replaceParagraph(textFlow:TextFlow,paragraph:ParagraphElement,index:int):TextFlow
		{
			textFlow.replaceChildren(index, index + 1, paragraph);
			return textFlow;	
		}
		
		
		public static function addImageElement(textFlow:TextFlow,paragraphIndex):TextFlow
		{
			var imageSpan:ImageSpen = new ImageSpen();
			imageSpan.insertImageInTextFlow(textFlow, paragraphIndex);
			textFlow=imageSpan.textFlow
			
			return textFlow;
		}
		
		public static function splitParagraph(textFlow:TextFlow, position:Number):TextFlow
		{
			  var para:ParagraphElement = textFlow.findLeaf(position).getParagraph(); 
			  var newPara:ParagraphElement = para.splitAtPosition(position) as ParagraphElement;
			  return textFlow;
		}
		
		public static function mergParagraph(textFlow:TextFlow, position:Number):TextFlow
		{
			
			return textFlow;
		}
				
		private static function getParagraphElements(text:String):Vector.<ParagraphElement>
		{
			var textParagraphs:Array = text.split("\n");
			var result:Vector.<ParagraphElement> = new Vector.<ParagraphElement>();
			for (var i:uint = 0; i < textParagraphs.length; i++)
			{
				var p:ParagraphElement = new ParagraphElement();
				var span:SpanElement = new SpanElement();
				span.text = textParagraphs[i];
				p.addChild(span);
				result.push(p);
			}
			
			return result;
		}
		
		
		
		
	}
	
}
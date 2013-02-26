/**
* ...
* @author Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:6 August 2012
* Last Updated Date: 10 August 2012
* 
*/
package com.application.view
{
	import __AS3__.vec.Vector;
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.engine.TextLine
	import flash.text.TextFormat;
	
	import fl.events.ListEvent;
	import fl.text.TLFTextField;
	
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.edit.SelectionFormat;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.*;
	import flashx.textLayout.conversion.*;
			
	import com.application.util.TextFlowUtilities;		
	import com.application.view.TreeComponent;
	import com.application.events.TreeEvent;
	import com.application.util.ArrayUtilities;
	import com.application.view.ImageSpen;
	import com.yahoo.astra.fl.controls.treeClasses.*;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	public class TextView extends MovieClip
	{
		public var treeComponent:TreeComponent;
		public var mainTextFlow:TextFlow;
		private var _fileContentText:String;
		private var leafXML:XML;
		private var mainLeafArray:Array;
		private var _selectedParagraphIndex:int;
		private var _getSelectedParaText:String;
		private var activePos:int = 0;
		
		/**
		 * TextView Constructor.
		 * Type:Public Function
		 * @param none
		 * @return none
		 */
		public function TextView()
		{
			tlfTxt.addEventListener(MouseEvent.CLICK, onTextClick);
		}
		
		/**
		 * public mathod to initalize text area.
		 * Type:Public Function.
		 * @param String.
		 * @return none
		 */
		public function init(fileContentText:String):void
		{
			
			treeComponent = new TreeComponent();
			treeComponent.x = 23;
			treeComponent.y = 330;
			MovieClip(this.parent).addChildAt(treeComponent,2);
			treeComponent.addEventListener(TreeEvent.NODE_CLICK, onTreeClickHandler);
			
			mainTextFlow = new TextFlow();
			mainTextFlow = TextConverter.importToFlow(fileContentText, TextConverter.PLAIN_TEXT_FORMAT);
			
			mainTextFlow.paddingTop = 10;
			mainTextFlow.paddingLeft = 10;
			mainTextFlow.fontSize = 12;
			mainTextFlow.fontFamily = "Verdana"
			mainTextFlow.paragraphSpaceAfter = 10;
			
			tlfTxt.textFlow = mainTextFlow;
			reFormateTextFlow();
			mainTextFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * public mathod to update main text flow of text ariea.
		 * Type:Public Function.
		 * @param none
		 * @return none
		 */
		public function update()
		{
			tlfTxt.text = fileContentText;
		}
		
		/**
		 * public mathod to upate paragraph after editing.
		 * Type:Public Function.
		 * @param ParagraphElement
		 * @return none
		 */
		public function updateEditText(paragraph:ParagraphElement)
		{
			mainTextFlow.replaceChildren(_selectedParagraphIndex, _selectedParagraphIndex + 1, paragraph);
			
			tlfTxt.textFlow = mainTextFlow;
			mainTextFlow.flowComposer.updateAllControllers();
			reFormateTextFlow2();
			var _text:String = TextConverter.export(tlfTxt.textFlow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE) as String;
			trace(_text);
		}
		
		/**
		 * public mathod to add image element in TextFlow.
		 * Type:Public Function.
		 * @param ParagraphElement
		 * @return none
		 */
		public function addImageElement()
		{
			var imageSpan:ImageSpen = new ImageSpen();
			imageSpan.insertImageInTextFlow(mainTextFlow, _selectedParagraphIndex);
			mainTextFlow=imageSpan.textFlow
			tlfTxt.textFlow = imageSpan.textFlow;
			mainTextFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * public mathod to remove paragraph from text flow object.
		 * Type:Public Function.
		 * @param none
		 * @return none
		 */
		public function removeNode()
		{
			if(mainTextFlow)
			{
			mainTextFlow=TextFlowUtilities.removeParagraph(mainTextFlow,_selectedParagraphIndex)
			mainTextFlow.flowComposer.updateAllControllers();
			reFormateTextFlow2();
			}
			else
			{
				AlertManager.createAlert(this, "Import Text From Text File ", "Text Area is Empty ", ["OK"], null, "warningIcon");
			}
		}
		
		/**
		 * public mathod to add paragraph in text flow object.
		 * Type:Public Function.
		 * @param ParagraphElement
		 * @return none
		 */
		public function addNode()
		{
			if(mainTextFlow)
			{
			 mainTextFlow=TextFlowUtilities.addParagraph(mainTextFlow,_selectedParagraphIndex);
			 mainTextFlow.flowComposer.updateAllControllers();
			 reFormateTextFlow2();
			}
			else
			{
				AlertManager.createAlert(this, "Import Text From Text File ", "Text Area is Empty ", ["OK"], null, "warningIcon");
			}
		}
		/**
		 * public mathod to add Sound with paragraph.
		 * Type:Public Function.
		 * @param ParagraphElement
		 * @return none
		 */
		public function addSoundInParagraph()
		{
			TextFlowUtilities.setParagraphProperty(mainTextFlow,_selectedParagraphIndex,"id","1");
			TextFlowUtilities.traceTextFlow(mainTextFlow)
		}
		
		public function splitParagraph()
		{
				
			mainTextFlow = TextFlowUtilities.splitParagraph(mainTextFlow,activePos);
			TextFlowUtilities.traceTextFlow(mainTextFlow)
		}
		
		/**
		 * Public properties to get and set variable at runtime .
		 * Type:Public Function.
		 */		
		public function get fileContentText():String
		{
			return _fileContentText;
		}
		
		public function set fileContentText(value:String):void
		{
			_fileContentText = value;
		}
		
		public function get getSelectedParaText():String
		{
			return _getSelectedParaText;
		}
		
		public function set getSelectedParaText(value:String):void
		{
			_getSelectedParaText = value;
		}
		
		public function get selectedParagraphIndex():int
		{
			return _selectedParagraphIndex;
		}
		
		public function set selectedParagraphIndex(value:int):void
		{
			_selectedParagraphIndex = value;
		}
		
		
		/**
		 * function to handle tree component node click.
		 * Type:Private Function.
		 * @param event
		 * @return none
		 */
		private function onTreeClickHandler(evt:TreeEvent)
		{
			
			var id:Number = Number(evt.id)
			if(isNaN(id))
			{
			
			}
			else
			{
			var leafArray:Array = tlfTxt.textFlow.mxmlChildren
			ParagraphElement(leafArray[0]).getFirstLeaf().text
			selectSpan(ParagraphElement(leafArray[id]).getFirstLeaf().getParagraph().parentRelativeStart, ParagraphElement(leafArray[id]).getFirstLeaf().getParagraph().parentRelativeEnd)
			}
		}
		
		/**
		 * function to handle paragraph click.
		 * Type:Private Function.
		 * @param event
		 * @return none
		 */
		private function onTextClick(evt:MouseEvent)
		{
			
			var leaf:ParagraphElement = new ParagraphElement();
			leaf = ParagraphElement(tlfTxt.textFlow.getChildAt(0));
			
			activePos = tlfTxt.selectionBeginIndex;
			var spanStart:int = leaf.parentRelativeStart;
			var spanEnd:int = leaf.parentRelativeEnd;
			trace(activePos);
			if(evt.target is TextLine || evt.target is SimpleButton)
			{
				if (activePos >= spanStart && activePos <= spanEnd)
				{
					
					selectSpan(spanStart, spanEnd);
					_selectedParagraphIndex = mainTextFlow.getChildIndex(leaf)
					_getSelectedParaText = leaf.getText();
					treeComponent.selectNode(String(_selectedParagraphIndex));
					trace(mainTextFlow.getChildIndex(leaf));
					return;
				}
				
				while (leaf = ParagraphElement(leaf.getNextParagraph()))
				{
					
					spanStart = leaf.parentRelativeStart;
					spanEnd = leaf.parentRelativeEnd;
					if (activePos >= spanStart && activePos <= spanEnd)
					{
						
						selectSpan(spanStart, spanEnd);
						_selectedParagraphIndex = mainTextFlow.getChildIndex(leaf)
						_getSelectedParaText = leaf.getText();
						treeComponent.selectNode(String(_selectedParagraphIndex));
						trace(mainTextFlow.getChildIndex(leaf));
						return;
					}
				}
			}
		}
		
		/**
		 * function to reformate text flow object at runtime.
		 * Type:Private Function.
		 * @param none
		 * @return none
		 */
		private function reFormateTextFlow():void
		{	leafXML = null;
			leafXML = new XML("<node><node label='Chapter 1'></node></node>");
			var leafArray:Array = tlfTxt.textFlow.mxmlChildren;
			
			
			for (var i=0; i < leafArray.length; i++)
			{
				leafXML.node.appendChild(<node></node>);
				leafXML.node.node[i].@label = ParagraphElement(leafArray[i]).getText().substr(0, 32);
				leafXML.node.node[i].@id = i;
					
			}
			trace(leafXML)
			treeComponent.dataProvider = leafXML;
			mainTextFlow = tlfTxt.textFlow;
			selectedParagraphColor(mainTextFlow);
		
		}
		
		/**
		 * function to reformate text flow object at runtime.
		 * Type:Private Function.
		 * @param none
		 * @return none
		 */
		private function reFormateTextFlow2():void
		{
			
			leafXML = null;
			leafXML = new XML("<node><node label='Chapter 1'></node></node>");
			var txtString:String = "";
			var leafArray:Array = tlfTxt.textFlow.mxmlChildren;
			
			for (var i = 0; i < leafArray.length ; i++)
			{
				leafXML.node.appendChild(<node></node>);
				leafXML.node.node[i].@label = ParagraphElement(leafArray[i]).getText().substr(0,32);
				leafXML.node.node[i].@id = i;
			}
			
			treeComponent.dataProvider = leafXML;
			selectedParagraphColor(mainTextFlow);
		
		}
		
		/**
		 * function to set selection for paragraph.
		 * Type:Private Function.
		 * @param int,int.
		 * @return none
		 */
		private function selectSpan(i1:int, i2:int):void
		{
			tlfTxt.textFlow.interactionManager.setFocus();
			tlfTxt.setSelection(i1, i2);
		}
		
		/**
		 * function to set color of selected paragraph.
		 * Type:Private Function.
		 * @param TextFlow
		 * @return none
		 */
		private function selectedParagraphColor(textFlow:TextFlow)
		{
			var fSelFmt:ISelectionManager = textFlow.interactionManager;
			fSelFmt.focusedSelectionFormat = new SelectionFormat(0x53BAFF, 1, BlendMode.NORMAL);
			textFlow.interactionManager = fSelFmt;
		}
				
	
	}
}
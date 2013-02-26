/**
 * ...
 * @author Rapidsoftsys
 * Singleton Class to access data in application 
 * Started Date:6 August 2012
 * Last Updated Date: 10 Sept. 2012
 * 
 */
package com.application.view {
	import flash.display.MovieClip
		import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	
	
	public class TextEditor extends MovieClip implements IEventDispatcher{
		private var myText:String;
		private var myText_orig:String;
		private var _mainText:TextField;
		private var userFonts:Array;
		private var allFontNames:Array;
		
		//Registers the event listeners for outside use
		public static const ON_TEXT_SAVED:String = "onTextSaved";
		
		
		public function TextEditor(text:String = null) {
			_mainText = mainText;
			text ? myText = text : myText = "Add your paragraph";
			myText_orig = myText;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event):void {
			_mainText.htmlText = myText;
			_mainText.alwaysShowSelection = true;
			enableButtons();
			_mainText.addEventListener(MouseEvent.MOUSE_UP, checkTextFormat);
			
			// Load the fonts from the user's computer into the combobox
			userFonts = Font.enumerateFonts(true);
			userFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			
			allFontNames = new Array();
			fontList.addItem( { label: "" } );
			allFontNames.push("");
			
			for (var i = 0; i < userFonts.length; i++ ) {
				fontList.addItem( { label: userFonts[i].fontName } );
				allFontNames.push(userFonts[i].fontName);
			}
		}
		
		
		
		
		
		//____________________________________________________________________Button Actions
		
		private function enableButtons():void {
			
			// Save / undo
			button.focusEnabled = false;
			button.addEventListener(MouseEvent.CLICK, submitText);
			undoBtn.focusEnabled = false;
			undoBtn.addEventListener(MouseEvent.CLICK, undoText);
			
			// BG Color Buttons
			Btn_black.buttonMode = true;
			Btn_black.addEventListener(MouseEvent.CLICK, changeBG);
			Btn_white.buttonMode = true;
			Btn_white.addEventListener(MouseEvent.CLICK, changeBG);
			
			// Components
			fontList.addEventListener(Event.CHANGE, changeFont);
			sizeSelect.addEventListener(Event.CHANGE, changeSize);
			colorSelect.addEventListener(Event.CHANGE, changeColor);
			
			// Custom Buttons
			buttonBold.buttonMode = true;
			buttonBold.addEventListener(MouseEvent.CLICK, changeBold);
			buttonItalic.buttonMode = true;
			buttonItalic.addEventListener(MouseEvent.CLICK, changeItalic);
			buttonUnderline.buttonMode = true;
			buttonUnderline.addEventListener(MouseEvent.CLICK, changeUnderline);
			buttonLeft.buttonMode = true;
			buttonLeft.addEventListener(MouseEvent.CLICK, setLeft);
			buttonCenter.buttonMode = true;
			buttonCenter.addEventListener(MouseEvent.CLICK, setCenter);
			buttonRight.buttonMode = true;
			buttonRight.addEventListener(MouseEvent.CLICK, setRight);
			
			// Link field + target
			//urlField.addEventListener(Event.CHANGE, setURL);
			//targetList.addEventListener(Event.CHANGE, setTarget);
		}		
		
		
		private function changeFont(e:Event):void {
			editTextFormat("font", e.target.selectedItem.label);
		}
		
		private function changeSize(e:Event):void {
			editTextFormat("size", e.target.value);
		}
		
		private function changeColor(e:Event):void {
			editTextFormat("color", e.target.selectedColor);
		}
		
		private function changeBold(e:Event):void {
			editTextFormat("bold");
		}
		
		private function changeItalic(e:MouseEvent):void {
			editTextFormat("italic");
		}
		
		private function changeUnderline(e:MouseEvent):void {
			editTextFormat("underline");
		}
		
		private function setLeft(e:MouseEvent):void {
			editTextFormat("left");
		}
		
		private function setCenter(e:MouseEvent):void {
			editTextFormat("center");
		}
		
		private function setRight(e:MouseEvent):void {
			editTextFormat("right");
		}
		
		private function setURL(e:Event):void {
			editTextFormat("url", e.target.text);
		}
		
		private function setTarget(e:Event):void {
			editTextFormat("target", e.target.selectedItem.data);
		}
		
		
		//___________________________________________________________________ Text Format Calculation and Editing
		
		private function checkTextFormat(e:Event = null):void {
			
			if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex)
			{
				
				var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);
				
				// Set the style buttons
				tempTextFormat.bold ? buttonBold.gotoAndStop("selected") : buttonBold.gotoAndStop("unselected");
				tempTextFormat.italic ? buttonItalic.gotoAndStop("selected") : buttonItalic.gotoAndStop("unselected");
				tempTextFormat.underline ? buttonUnderline.gotoAndStop("selected") : buttonUnderline.gotoAndStop("unselected");
				
				// Set the alignment button
				tempTextFormat.align == "left" ? buttonLeft.gotoAndStop("selected") : buttonLeft.gotoAndStop("unselected");
				tempTextFormat.align == "center" ? buttonCenter.gotoAndStop("selected") : buttonCenter.gotoAndStop("unselected");
				tempTextFormat.align == "right" ? buttonRight.gotoAndStop("selected") : buttonRight.gotoAndStop("unselected");
				
				// Set the color picker
				colorSelect.selectedColor = uint(tempTextFormat.color);
				
				// Set the font name
				tempTextFormat.font ? fontList.selectedIndex = allFontNames.indexOf(tempTextFormat.font) : fontList.selectedIndex = -1;
				
				// Set the font size
				sizeSelect.value = int(tempTextFormat.size);
				
				// Look for a link
				//tempTextFormat.url != null ? urlField.text = String(tempTextFormat.url) : urlField.text = "";
			}
		}
		
		
		//edits theactual text format
		private function editTextFormat(type:String, val:* = null) {
			
			if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex)
			{
				
				// Get the current Format
				var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);
				
				// Edit the Format
				switch(type)
				{
					case "font":
						tempTextFormat.font = val;
						break;
					case "size":
						tempTextFormat.size = val;
						break;
					case "color":
						tempTextFormat.color = val;
						break;
					case "bold":
						tempTextFormat.bold ? tempTextFormat.bold = false : tempTextFormat.bold = true;
						break;	
					case "italic":
						tempTextFormat.italic ? tempTextFormat.italic = false : tempTextFormat.italic = true;
						break;	
					case "underline":
						tempTextFormat.underline ? tempTextFormat.underline = false : tempTextFormat.underline = true;
						break;
					case "left":
						tempTextFormat.align = "left";
						break;				
					case "center":
						tempTextFormat.align = "center";
						break;				
					case "right":
						tempTextFormat.align = "right";
						break;			
					case "url":
						tempTextFormat.url = val;
						//tempTextFormat.target = targetList.selectedItem.data;
						val != "" ? tempTextFormat.underline = true : tempTextFormat.underline = false;
						break;
					case "target":
						tempTextFormat.target = val;
						break;							
					default:
				}
				
				// Apply the changed format
				_mainText.setTextFormat(tempTextFormat, _mainText.selectionBeginIndex, _mainText.selectionEndIndex);
				checkTextFormat();
			}
		}
		
		
		
		
		
		//______________________________________________________________________BG Color Switch
		
		private function changeBG(e:MouseEvent):void {
			
			var BGcolor:ColorTransform = new ColorTransform();
			
			if (e.target.name == "Btn_black") {
				BGcolor.color = 0x000000;	
			} else {
				BGcolor.color = 0xFFFFFF;	
			}
			background.txtBG.transform.colorTransform = BGcolor;
		}
		
		
		
		
		
		
		//______________________________________________________________________Text Saving
		
		private function submitText(e:MouseEvent):void {
			
			dispatchEvent(new Event(TextEditor.ON_TEXT_SAVED));
		}
		
		// Undo all changes
		private function undoText(e:MouseEvent):void {
			
			_mainText.htmlText = myText_orig;
		}
		
		
		
	}
	
}


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
	import flash.events.Event;
	import com.application.view.MenuBarNavigation;
	import com.application.models.ModelLocator;
	import com.application.controller.LoadTextController;
	import com.application.events.*
	import com.application.view.TextEditor;
	import com.application.view.SoundEditor;
	import makemachine.demos.audio.microphone.MicrophoneCapture;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.ParagraphElement;
	
	import flash.media.SoundMixer;
	
	public class ApplicationView extends MovieClip 
	{
		private var menuBarNav:MenuBarNavigation;
		private var _model:ModelLocator;
		private var _controller:LoadTextController;
		
		private var fileContentText:String;
		private var paragraphLoaded:Boolean = false;
		
		private var textEditor:TextEditor;
		private var soundEditor:SoundEditor;
		private var _microphoneCapture:MicrophoneCapture;
		
		
		/**
		 * Application Constructor.
		 * Type:Public Function
		 * @param ModelLocator ,LoadTextController
		 * @return Constructor
		 */
		public function ApplicationView(model:ModelLocator,controller:LoadTextController)
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			_model = model
			_controller = controller;
		}
		
		/**
		 * Application initialization.
		 * add Menu Items.
		 * Type:Private Function Event Handler
		 * @param none
		 * @return none
		 */
		private function init(evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			menuBarNav=new MenuBarNavigation(_model.menus);
			menuBarNav.addEventListener(MenubarEvent.MENU_ITEM_CLICK, onMenuItemClick);
			addChild(menuBarNav);
			
		}
		
		/**
		 * Menu Item Event Handler 
		 * Call different function on menu item click.
		 * Type:Private Function
		 * @param none
		 * @return none
		 */
		private function onMenuItemClick(evt:MenubarEvent) {
			setChildIndex(menuBarNav,numChildren-1);
			Main._root.textModule.tlfTxt.textFlow.interactionManager.setFocus();
			switch (evt.id) {
				case "Create From Text" :
					loadText();
					break;

				case "Add Paragraph" :
					addParagraph();
					break;

				case "Remove Paragraph" :
					removeParagraph();
					break;

				case "Edit Paragraph" :
					addTextEditer();
					break;

				case "Record Sound" :
					addRcorderToStage();
					break;

				case "Import Audio" :
					importSound();
					break;

				case "Sync Audio" :
					//addImageElement();
					break;

			}
		}
		/**
		 * function to load external text file.
		 * Type:Private Function.
		 * @param none
		 * @return none
		 */
		private function loadText():void {
			
			_model.addEventListener(ModelEvent.UPDATE,loadComplete);
			_controller.load();
			_controller.addEventListener("TextError",onTextErrorHandler);
			
		}
		
		/**
		 * function to handle error while loading Text file.
		 * Type:Private Function Event Handler
		 * @param event
		 * @return none
		 */
		private function onTextErrorHandler(evt:Event)
		{
			AlertManager.createAlert(MovieClip(this.parent), "Text File is empty ", "Open Text File", ["OK"], null, "warningIcon");
		}
		
		/**
		 * function to get text after loding Text file.
		 * Type:Private Function Event Handler.
		 * @param event
		 * @return none
		 */
		private function loadComplete(e:ModelEvent):void {
			paragraphLoaded = true;
			fileContentText = e.target.text;
			Main._root.textModule.init(fileContentText);
		}
		
		/**
		 * function to remove paragraph from text area.
		 * Type:Private Function .
		 * @param none
		 * @return none
		 */
		private function removeParagraph():void {
			Main._root.textModule.removeNode();
		}

		/**
		 * function to add paragraph from text area.
		 * Type:Private Function .
		 * @param none
		 * @return none
		 */
		private function addParagraph():void {
			Main._root.textModule.addNode();
		}
		
		/**
		 * function to edit paragraph text at run time.
		 * Type:Private Function .
		 * @param none
		 * @return none
		 */
		private function addTextEditer():void {
			if (paragraphLoaded)
			{
			textEditor = new TextEditor(Main._root.textModule.getSelectedParaText);
			textEditor.x = stage.stageWidth / 2;
			textEditor.y = stage.stageHeight / 2;

			addChildAt(textEditor,numChildren-1);
			textEditor.addEventListener(TextEditor.ON_TEXT_SAVED, onTextSavedHandler);
			}
			else
			{
				AlertManager.createAlert(MovieClip(this.parent), "Import Text From Text File ", "Text Editor", ["OK"], null, "warningIcon");
			}
		}
		
		/**
		 * function to save changes in text.
		 * Type:Private Function Event Handler.
		 * @param event
		 * @return none
		 */
		private function onTextSavedHandler(e:Event):void {
			var htmlText:String = textEditor.mainText.htmlText;
			var textFlow:TextFlow = TextConverter.importToFlow(htmlText,TextConverter.TEXT_FIELD_HTML_FORMAT);
			Main._root.textModule.updateEditText(ParagraphElement(textFlow.getChildAt(0)));
			removeChild(textEditor);
		}
		
		
		/**
		 * function to add audio recorder component on stage.
		 * Type:Private Function.
		 * @param event
		 * @return none
		 */
		var isMicropHone:Boolean=false;
		private function addRcorderToStage()
		{
			if (soundEditor != null) {
				removeChild(soundEditor);
				soundEditor=null
			}
			if(isMicropHone==false)
			{
				 SoundMixer.stopAll(); 
			_microphoneCapture = new MicrophoneCapture();
			_microphoneCapture.x = 330;
			_microphoneCapture.y = 65;
			addChildAt(_microphoneCapture,0);
			isMicropHone=true;
			isSoundEditor=false;
			}
		}
		
		/**
		 * function to add audio import tool on stage.
		 * Type:Private Function.
		 * @param event
		 * @return none
		 */
		var isSoundEditor:Boolean=false;
		private function importSound() {
			if (_microphoneCapture != null) {
				removeChild(_microphoneCapture);
				_microphoneCapture=null;
			}
			if(isSoundEditor==false)
			{
				 SoundMixer.stopAll(); 
			soundEditor = new SoundEditor();
			soundEditor.x = 325;
			soundEditor.y = 174;
			addChildAt(soundEditor, numChildren-1);
			isSoundEditor=true;
			isMicropHone=false;
			}
			
		}
		
		/**
		 * function to add image at runtime in text area.
		 * Type:Private Function.
		 * @param event
		 * @return none
		 */
		private function addImageElement() {
			Main._root.textModule.addImageElement();

		}
	}
	
}
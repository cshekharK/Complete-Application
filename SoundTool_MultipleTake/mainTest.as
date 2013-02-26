package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.application.controller.audioController
	import com.application.view.SoundEditor;
	import flash.display.MovieClip;
	
	import com.application.events.ModelEvent;
	import com.application.model5.ModelLocator5;
	
		public class mainTest extends MovieClip {//extends MovieClip 
		
		private var _audioController:audioController;
		private var _sounEditor:SoundEditor;
		
		public var _model:ModelLocator5;
		
		private var _listContainer:Sprite;
		
		
		public function mainTest():void {
			
			_model = ModelLocator5.getInstance();
			
			paragraph_1.buttonMode = paragraph_2.buttonMode = paragraph_3.buttonMode = paragraph_4.buttonMode = paragraph_5.buttonMode = paragraph_6.buttonMode = true;
			paragraph_1.mouseChildren = paragraph_2.mouseChildren = paragraph_3.mouseChildren = paragraph_4.mouseChildren = paragraph_5.mouseChildren = paragraph_6.mouseChildren = false;
			paragraph_1.text_txt.text = "Paragraph 1";
			paragraph_2.text_txt.text = "Paragraph 2";
			paragraph_3.text_txt.text = "Paragraph 3";
			paragraph_4.text_txt.text = "Paragraph 4";
			paragraph_5.text_txt.text = "Paragraph 5";
			paragraph_6.text_txt.text = "Paragraph 6";
			paragraph_1.addEventListener(MouseEvent.CLICK, paragraph1Cliked);
			paragraph_2.addEventListener(MouseEvent.CLICK, paragraph2Cliked);
			paragraph_3.addEventListener(MouseEvent.CLICK, paragraph3Cliked);
			paragraph_4.addEventListener(MouseEvent.CLICK, paragraph4Cliked);
			paragraph_5.addEventListener(MouseEvent.CLICK, paragraph5Cliked);
			paragraph_6.addEventListener(MouseEvent.CLICK, paragraph6Cliked);
			
			export_btn.addEventListener(MouseEvent.CLICK, exportCliked);
			import_btn.addEventListener(MouseEvent.CLICK, importCliked);
			delete_btn.addEventListener(MouseEvent.CLICK, deleteCliked);
			add_btn.addEventListener(MouseEvent.CLICK, addCliked);
			
			_audioController = audioController.getInstance();
			
			_sounEditor = new SoundEditor();
			_sounEditor.x = 271;
			_sounEditor.y = 145.15;
			addChild(_sounEditor);
			
			_model.addEventListener(ModelEvent.SHOW_AUDIO_LIST, showAudioList);
			_model.addEventListener(ModelEvent.NEW_PARAGRAPH_SELECTED, onNewParagraph);
			
			_listContainer = new Sprite();
			_listContainer.x = 1300;
			_listContainer.y = 300;
			addChild(_listContainer)
		}
		private function showAudioList(e:ModelEvent):void {
			for (var i = 0; i < e.data.audios.length; i++ ) {
				//trace(e.data.audios[i].date)
				//trace(e.data.audios[i].audio)
				var item:listItem = new listItem();
				item.audio = e.data.audios[i].audio;
				item.y = i * 24;
				item.mouseChildre = false;
				item.buttonMode = true;
				var k:int = i + 1;
				item.text_txt.text = "Take " + k +".mp3";
				item.addEventListener(MouseEvent.CLICK, itemClicked);
				_listContainer.addChild(item);
			}
		}
		private function onNewParagraph(e:ModelEvent):void {
			while (_listContainer.numChildren > 0) {
				_listContainer.getChildAt(0).removeEventListener(MouseEvent.CLICK, itemClicked);
				_listContainer.removeChildAt(0);
			}
		}
		private function itemClicked(e:MouseEvent):void {
			var data:Object = new Object();
			data["audio"] = e.currentTarget.audio
			_model.dispatchEvent(new ModelEvent(ModelEvent.AUDIO_LIST_SELECTED, data));
		}
		private function addCliked(e:MouseEvent):void {
			_audioController.addAudioWave();
		}
		private function deleteCliked(e:MouseEvent):void {
			_audioController.removeAudioWave();
		}
		private function exportCliked(e:MouseEvent):void {
			_audioController.exportAudio();
		}
		private function importCliked(e:MouseEvent):void {
			_audioController.importAudio();
		}
		private function paragraph1Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","1");
		}
		private function paragraph2Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","2");
		}
		private function paragraph3Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","3");
		}
		private function paragraph4Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","4");
		}
		private function paragraph5Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","5");
		}
		private function paragraph6Cliked(e:MouseEvent):void {
			_audioController.selectParagraph("2","6");
		}
	}
}
/**
 * ...
 * @author Rapidsoftsys
 * Started Date:13 August 2012
 * Last Updated Date: 10 Sept. 2012
 *
 */
package com.application.view
{
	import cmodule.shine.CLibInit;
	
	import com.application.controller.audioController;
	import com.application.events.CustomSliderEvent;
	import com.application.events.ModelEvent;
	import com.application.events.SoundEditorEvent;
	import com.application.model5.ModelLocator5;
	import com.application.util.AudioUtilities;
	import com.application.util.EncodeUtil;
	import com.application.util.HtmlEntities;
	import com.application.util.StringUtilities;
	import com.application.util.UploadPostHelper;
	import com.application.util.WavToMp3Bytes;
	import com.automatastudios.audio.audiodecoder.decoders.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.org.as3wavsound.WavSound;
	import com.org.as3wavsound.WavSoundChannel;
	import com.org.audiofx.mp3.*;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import fl.events.ScrollEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundCodec;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.*;
	//import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.*;
	
	import makemachine.demos.audio.microphone.capture.*;
	
	
	
	
	public class SoundEditor extends MovieClip
	{	
		//private var fileReference:FileReference;
		private var sound:Sound = new Sound();
		private var channel:SoundChannel = new SoundChannel();
		private var sound_st:SoundTransform = new SoundTransform(1, 0);
		private var samples:ByteArray = new ByteArray();
		private var buffer:BitmapData = new BitmapData(1150, 150, true, 0xffffff);
		private var selectBuffer:BitmapData = new BitmapData(1150, 157, true,0);
		private var selectScreen:Bitmap = new Bitmap(selectBuffer);
		private var screen:Bitmap = new Bitmap(buffer);
		
		private var soundPos:Number = 0;
		
		private var rect:Rectangle = new Rectangle(0, 0, 1, 0);
		private var playingTime:int;
		private var ratio:Number;
		private var step:int;
		
		private var selectionRect:Rectangle = new Rectangle(0, 0, 0, 1150);
		private var clickedPosition:int;
		private var looper:Timer = new Timer(0, 0);
		
		private var output = new Sound();
		private var bytes:ByteArray = new ByteArray();
		private var recordedBytes:ByteArray = new ByteArray();
		
		//private var wavData:ByteArray;//removed by oscar 10/01/13
		private var mp3Data:ByteArray;
		private var cshine:Object;
		private var timer:Timer;
		private var initTime:uint;
		
		
		
		private var capture:MicrophoneInput;
		
		private var bufferBytes:ByteArray;
		public static const BUFFER_SIZE:int = 8192;
		public static const SAMPLE_RATE:int = 44100;
		private var isCaptureStart:Boolean = false;
		private var playing:Boolean;
		private var isSoundPlaying:Boolean = false;
		private var isSoundLoaded:Boolean = false;
		
		public var _model:ModelLocator5;//added by bala to use in text editor
		public var _controller:audioController;//added by bala to use in anywhere
		
		private var _addSound:Boolean = false;
		private var _mp3bytesToSaveFileOnServer:ByteArray = new ByteArray();
		
		
		
		/**
		 * SoundEditor Constructor.
		 * Type:Public Function
		 * @param model.
		 * @param controller.
		 * @return none
		 */
		public function SoundEditor():void
		{
			
				addEventListener(Event.ADDED_TO_STAGE, init);
				_model = ModelLocator5.getInstance();
				//_controller = new audioController();
				_controller = audioController.getInstance();//changed by oscar 18/02/13
				EncodeUtil;
				StringUtilities;
				HtmlEntities;
		}
		
		/**
		 * function to initalize SoundEditor .
		 * Type:Private Function Event Handler;
		 * @param none.
		 * @return none
		 */
		private function init(evt:Event)
		{
			soundGraph_mc.addChild(screen);
			
			soundGraph_mc.addChild(selectScreen);
			selectScreen.y = -15;
			//setChildIndex(mc, numChildren - 1);
						
			looper.addEventListener(TimerEvent.TIMER, onTime);
			trace("init...",soundGraph_mc,_model)
			soundGraph_mc.addEventListener(MouseEvent.MOUSE_UP, onClick);
			soundGraph_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseIsDown);
						
			//fileReference = new FileReference();
			//fileReference.addEventListener(Event.SELECT, fileReferenceSelectHandler);
						
			slider_cmp.value = 100;
			slider_cmp.startCmp = true;
			slider_cmp.addEventListener(CustomSliderEvent.ON_CHANGE, onDrag);
			
			micGainSlider_mc.value = 50;
			micGainSlider_mc.startCmp = true;
			micGainSlider_mc.addEventListener(CustomSliderEvent.ON_CHANGE, onGainSlider);
			trace("init...2",soundGraph_mc,_model)
			cutSound_mc.buttonMode = true;
			record_btn.mouseChildren=false
			playPause_mc.buttonMode = true;
			record_btn.buttonMode = true;
			saveAudio_mc.buttonMode = true;
			stopPlayBack_mc.buttonMode = true;
			reset_btn.buttonMode = true;
			//saveRecord_btn.buttonMode = true;
			//loadFile_mc.addEventListener(MouseEvent.CLICK, selectFileHandler);
			cutSound_mc.myname="Crop Audio"
			playPause_mc.myname = "Play/Pause"
			//saveRecord_btn.myname = "Finish Recording"
			saveAudio_mc.myname="Export Audio"
			record_btn.myname="Record"
			reset_btn.myname="Refresh"
			stopPlayBack_mc.myname ="Stop"
			trace("init...3",soundGraph_mc,_model)
			cutSound_mc.addEventListener(MouseEvent.CLICK, cutAnwantedSound);
			playPause_mc.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			//saveRecord_btn.addEventListener(MouseEvent.CLICK, saveRecordedSound)
			saveAudio_mc.addEventListener(MouseEvent.CLICK, saveAudioFile);  //bala
			record_btn.addEventListener(MouseEvent.CLICK, onRecordPauseToggle);// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ENABLE THIS BUTTON JUST IF THERE'S A PARAGRAPH SELECTED
			reset_btn.addEventListener(MouseEvent.CLICK, onResetButton);
			stopPlayBack_mc.addEventListener(MouseEvent.CLICK, stopPlayBack);
			trace("init...4",soundGraph_mc,_model)
			createAudio();
			trace("init...5",soundGraph_mc,_model);
			_model.addEventListener(ModelEvent.RECORD_SOUND, onRecordSound);//added by oscar 10/01/13
			_model.addEventListener(ModelEvent.SHOW_SOUND, onShowSound);//added by oscar 10/01/13
			_model.addEventListener(ModelEvent.NEW_PARAGRAPH_SELECTED, onNewParagraphSelected);//added by oscar 10/01/13
			_model.addEventListener(ModelEvent.REMOVE_WAVE_SELECTED, onRemoveWaveSelected);//added by oscar 11/02/13
			_model.addEventListener(ModelEvent.ADD_WAVE_SELECTED, onAddWaveSelected);//added by oscar 12/02/13
			//_model.addEventListener(ModelEvent.NO_AUDIO_ON_SERVER, onShowSound);//added by oscar 10/01/13
			trace("init...6",soundGraph_mc,_model);
			
		}
		private function onAddWaveSelected(ev:ModelEvent):void {//function added by oscar 12/02/13
			if (this.selectionRect.width > 5) {
				_addSound  = true;
				onRecordPauseToggle();
			}
		}
		
		private function onRemoveWaveSelected(ev:ModelEvent):void {//function added by oscar 11/02/13
			
			if (this.selectionRect.width > 5) {
				
				var lenght:* = Math.floor(this.ratio * this.selectionRect.x * 0.001 * 44100);
				var tempData1:ByteArray = new ByteArray();
				tempData1.endian = Endian.LITTLE_ENDIAN;
				sound.extract(tempData1, lenght, 0);
				
				lenght = Math.floor(this.ratio * (buffer.rect.width - (this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100);
				
				var tempData2:ByteArray = new ByteArray();
				tempData2.endian = Endian.LITTLE_ENDIAN;
				sound.extract(tempData2, lenght, (Math.floor(this.ratio * ((this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100)));
				
				tempData2.position = 0;
				tempData1.writeBytes(tempData2);
				
				/*var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(tempData1));
				wevTomMp3.addEventListener("mp3Bytes", onMp3Conveted);*/
				
				convertWavToMp3(tempData1);
				/*
				var wevTomMp3:WavToMp3Bytes;
				wevTomMp3 = new WavToMp3Bytes(finalData);
				wevTomMp3.addEventListener("mp3Bytes", onMp3Conveted);
				wevTomMp3.addEventListener("progress", onMp3progress);
				*/
				//sound.
				//sound.extract(finalData, lenght, this.selectionRect.x * this.ratio * 0.001 * 44100);
				//var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(_loc_3));
				//wevTomMp3.addEventListener("mp3Bytes", onMp3tempConveted);   ///SAVE audio....
			}
		}
		private function onNewParagraphSelected(ev:ModelEvent):void //function added by oscar 07/02/13
		{
			trace("New Paragraph Selected")
			buffer.fillRect(buffer.rect, 0);
			//buffer.dispose();
		}
		private function onShowSound(ev:ModelEvent):void //function added by oscar 10/01/13
		{
			trace("extension : " + ev.data.extension);
			//ev.data.audioData;
			
			isSoundLoaded = true;
			processByteArrayData(ev.data.extension, ev.data.audioData);
		}
		
		//bala added
		public function onRecordSound(ev:ModelEvent):void //function added by oscar 10/01/13
		{
			trace("onRecordSound1")
			onRecordPauseToggle();
			trace("onRecordSound")
		}
		
		/**
		 * function to handle file content after load complete MP3 and Wav format.
		 * Type:Private Function Event Handler.
		 * @param event
		 * @return none
		 */
		
		/*private function onfileOpenLoad(ev:Event):void
		{
			isSoundLoaded = true;
			
			//wavData = fileReference.data;//removed by oscar 10/01/13
			
			processByteArrayData(fileExtension, fileReference.data);*/
			/*if (fileExtension == "mp3")//moved into a function by oscar 10/01/13
			{
				var _createSWFFromMP3 = new CreateSWFFromMP3();
				var swf:ByteArray = _createSWFFromMP3.swf(wavData);
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
				loader.loadBytes(swf);
			}
			
			else if(fileExtension == "wav")
			{
				convertWavToMp3(wavData);
			}*/
		//}
		
		private function processByteArrayData($extension:String, $bytes:ByteArray):void {//added by oscar 10/01/13
			if ($extension == "mp3"){
				createSWFFromMP3($bytes);
			}else if($extension == "wav") {
				convertWavToMp3($bytes);
			}
		}
		private function convertWavToMp3(bytes:ByteArray):void {
			var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(bytes));
			wevTomMp3.addEventListener("mp3Bytes", onMp3Conveted);
			wevTomMp3.addEventListener("progress", onMp3progress);
		}
		private function onMp3progress(evt:Event):void {
			if (evt.target.percentage < 100) {
				recordTime_txt.text = "00:00:" + evt.target.percentage + "%";
			}
		}
		private function onMp3Conveted(evt:Event):void {
			isSoundLoaded = true;
			recordTime_txt.text = "00:00:00";
			evt.target.removeEventListener("progress", onMp3progress);
			evt.target.removeEventListener("mp3Bytes", onMp3Conveted);
			
			if (evt.target.mp3bytes.length > 0) {
				createSWFFromMP3(evt.target.mp3bytes);
			}else{
				dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Selected Enough Bytes"));
				//AlertManager.createAlert(MovieClip(this.parent), "Select Valid .Mp3 or .Wav file", "Sound Editor", ["OK"], null, "warningIcon");
			}
		}
		private function createSWFFromMP3($bytes:ByteArray):void {
			var _createSWFFromMP3 = new CreateSWFFromMP3();
			createAudioToSave($bytes);
			var swf:ByteArray = _createSWFFromMP3.swf($bytes);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			loader.loadBytes(swf);
		}
		
		private function createAudioToSave($data:ByteArray):void {//used to have a copy of the mp3 all the time to be sent 19/02/13
			saveAudio_mc.mouseEnabled = true
			saveAudio_mc.alpha = 1;
			_mp3bytesToSaveFileOnServer.clear();
			_mp3bytesToSaveFileOnServer.writeBytes($data);
		}
		
		private function onProgressHandler(evt:ProgressEvent)
		{
			//progress_txt.text=evt.tar
		}
		
		/**
		 * function to handle INIT event of loader for swfByteArray.
		 * Type:Private Function Event Handler.
		 * @param ProgressEvent.
		 * @return none
		 */
		private function initHandler(e:Event):void
		{
			sound = null;
			var SoundClass:Class = LoaderInfo(e.currentTarget).applicationDomain.getDefinition("MP3Wrapper_soundClass") as Class;
			sound = new SoundClass() as Sound;
			loadComplete();
		
		}
		
		/**
		 * function to handle file selection form local disc.
		 * Type:Private Function Event Handler.
		 * @param Event.
		 * @return none
		 */
		//var fileExtension:String;
		/*
		private function fileReferenceSelectHandler(ev:Event):void
		{
			fileReference.load();
			fileReference.addEventListener(Event.COMPLETE, onfileOpenLoad);
			var soundFileName = fileReference.name;
			fileExtension = getExtension(soundFileName);
		}
	*/
		
		/**
		 * function to scroll audio graph cusor.
		 * Type:Private Function Event Handler.
		 * @param Event.
		 * @return none
		 */
		private function scrollIt(e:Event):void
		{
			if (isSoundPlaying == true)
			{
				//trace("cursor_mc.x"+cursor_mc.x)//addChild(cursor_mc
				//trace(sound.length+":::"+channel.position)//addChild(cursor_mc
				
				cursor_mc.x = (1150 / playingTime) * channel.position;
				//cursor_mc.x = (buffer.width / playingTime) * channel.position
				audioPan_mc.tLevelL.height = (Math.round(channel.leftPeak * 100));
				audioPan_mc.tLevelR.height = (Math.round(channel.rightPeak * 100));
				
				recordTime_txt.text=AudioUtilities.toTimeCode(channel.position)
			}
		
		}
		
		/**
		 * function to make audio graph after load complete total bytes of audio.
		 * Type:Private Function Event Handler.
		 * @param Event.
		 * @return none
		 */
		private function loadComplete(event:Event = null):void
		{
			
			if(inst_mc)
			{
			removeChild(inst_mc)
			inst_mc=null
			}
			resetAllSoundObject();
			buffer.fillRect(buffer.rect, 0);
			samples.clear();
			
			var extract:Number = Math.floor((sound.length / 1000) * 44100);
			
			playingTime = sound.length;
			
			ratio = playingTime / 1150;
			//ratio = playingTime / buffer.width;
			var lng:Number = sound.extract(samples, extract);
			
			samples.position = 0;
			
			step = samples.length / 4096;
			do
			{
				step--;
			} while (step % 4);
			
			var left:Number;
			var right:Number;
			// graph height 60
			for (var c:int = 0; c < 4096; c++)
			{
				rect.x = c / 3.5;
				left = samples.readFloat() * 80;
				
				right = samples.readFloat() * 80;
				samples.position = c * step;
				if (left > 0)
				{
					rect.y = 60 - left;
					rect.height = left;
				}
				else
				{
					rect.y = 60;
					rect.height = -left;
				}
				buffer.fillRect(rect, 0xCCAA0000);
				
					//buffer.fillRect( rect, 0xFFFFFF );
			}
			//************************************************************************
			
			//if (this.selectionRect.width > 5)
			//{
			
				//trace("buffer.rect.width " + buffer.rect.width)
				//trace("buffer.rect.x " + buffer.rect.x)
				/*
				saveAudio_mc.mouseEnabled = false;
				saveAudio_mc.alpha = .5;
				//var _loc_2:* = Math.floor(this.ratio * this.selectionRect.width * 0.001 * 44100);
				var _loc_2:* = Math.floor(this.ratio * buffer.rect.width * 0.001 * 44100);
				var _loc_3:* = new ByteArray();
				_loc_3.endian = Endian.LITTLE_ENDIAN;
				//sound.extract(_loc_3, _loc_2, this.selectionRect.x * this.ratio * 0.001 * 44100);
				sound.extract(_loc_3, _loc_2, 0);// , this.selectionRect.x * this.ratio * 0.001 * 44100);
				var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(_loc_3));
				wevTomMp3.addEventListener("mp3Bytes", onMp3tempConveted);
				*/
				
			//}
			
			//sp_mc.source=soundGraph_mc;
		}
		
		
		/*private function onMp3tempConveted(evt:Event):void  //bala4
		{
			saveAudio_mc.mouseEnabled = true
			saveAudio_mc.alpha = 1;
			_mp3bytesToSaveFileOnServer = evt.target.mp3bytes;
		}*/
		
		/**
		 * function to play pause audio at runtime .
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
		public function onPlayPauseClick(evt:MouseEvent = null)
		{
			if (!capture.recording)
			{
			var frame:Number = (playPause_mc.currentFrame == 1) ? 2 : 1;
			
			sound_st.volume = 1;
			
			if (frame == 1)
			{
				soundPos = channel.position;
				channel.stop();
				isSoundPlaying = false;
				playPause_mc.gotoAndStop(frame);
				
			}
			else
			{
				if (isSoundLoaded == true)
				{
					channel.stop();
					channel = sound.play(soundPos);
					channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
					isSoundPlaying = true;
					playPause_mc.gotoAndStop(frame);
				}
				else
				{
					dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Import Sound"));
					//AlertManager.createAlert(MovieClip(this.parent), "Import Sound ", "Sound Editor", ["OK"], null, "warningIcon");
				}
			}
			channel.soundTransform = sound_st;
			stage.addEventListener(Event.ENTER_FRAME, scrollIt);
			}
		}
		
		private function onSoundCompleteHandler(evt:Event)
		{
			trace("Sound Complete::")
			cursor_mc.x = 0;
			isSoundPlaying = false;
			playPause_mc.gotoAndStop(1)
			channel.stop();
			soundPos = 0;
			//stage.removeEventListener(Event.ENTER_FRAME, scrollIt);
		}
		
		private function onTime(e:TimerEvent):void
		{
			if (isSoundPlaying == true)
			{
				channel.stop();
				channel = sound.play(selectionRect.x * ratio);
			}
		
		}
		
		/**
		 * function to get mouse position and set cursor position after mouse down on audio graph.
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
		private function onMouseIsDown(e:MouseEvent):void
		{
			trace(":this.moueX::"+this.mouseX)
			if (isSoundLoaded==true)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				selectBuffer.fillRect(selectBuffer.rect, 0);
				clickedPosition = this.mouseX;
				selectionRect.x = clickedPosition;
				selectionRect.width = 0;
			}
			
		}
		
		/**
		 * function to select part of aoudio graph at runtime on mouse move.
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
		private function onMove(e:MouseEvent):void
		{
			if (isSoundLoaded==true)
			{
			if (e.stageX > clickedPosition)
			{
				
				selectionRect.width = this.mouseX - clickedPosition;
			}
			else
			{
				
				selectionRect.x = e.stageX;
				selectionRect.width = Math.abs(this.mouseX - clickedPosition);
			}
			selectBuffer.fillRect(selectionRect, 0x33CCCC000);
			}
		}
		
		/**
		 * function to set cusor position after cliking on audio graph.
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
		private function onClick(e:MouseEvent):void
		{
			
			if (isSoundLoaded==true && isSoundPlaying==true)
			{
				channel.stop();
				channel = sound.play(selectionRect.x * ratio);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
				
				if (selectionRect.width)
				{
					looper.delay = ratio * selectionRect.width;
					looper.start();
				}else{
					looper.stop();
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			//bala added for fixing error  -  ************************************** ALL AUDIO IS SAVED ON TEMP FILE
			
			/*if (this.selectionRect.width > 5)
			{
				trace("this.selectionRect.width " + this.selectionRect.width)
				trace("this.selectionRect.x " + this.selectionRect.x)
				saveAudio_mc.mouseEnabled = false;
				saveAudio_mc.alpha = .5;
				var _loc_2:* = Math.floor(this.ratio * this.selectionRect.width * 0.001 * 44100);
				var _loc_3:* = new ByteArray();
				_loc_3.endian = Endian.LITTLE_ENDIAN;
				sound.extract(_loc_3, _loc_2, this.selectionRect.x * this.ratio * 0.001 * 44100);
				var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(_loc_3));
				wevTomMp3.addEventListener("mp3Bytes", onMp3tempConveted);   ///SAVE audio....
			}*/
		}
		
		
		
		/**
		 * function to select audio file form user local disc after clicking import audio button.
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
		/*public function selectFileHandler():void
		{
			if (!capture.recording)
			{
			fileReference.browse([new FileFilter("*.wav,*.mp3 files", "*.wav;*.mp3")]);
			}
		}*/
		
		/**
		 * function to encode and save file in wav formate after cliking save button.
		 * Type:Private Function Event Handler.
		 * @param MouseEvent.
		 * @return none
		 */
			 
		private function onDrag(evt:CustomSliderEvent)
		{
			SoundMixer.soundTransform = new SoundTransform(evt.data / 100);
		}
		private function onGainSlider(evt:CustomSliderEvent)
		{
			if (capture.recording)
			{
			   capture.microphone.gain = evt.data;
			}
		}
		
		
		public function saveAudioFile(event:MouseEvent=null):void
		{
			trace("SAVE audio....");
			/*if (this.selectionRect.width > 5)//removed by oscar 07/03/13 allow saving the whole wave
			{*/
				/*var _loc_2:* = Math.floor(this.ratio * this.selectionRect.width * 0.001 * 44100);
				var _loc_3:* = new ByteArray();
				_loc_3.endian = Endian.LITTLE_ENDIAN;
				sound.extract(_loc_3, _loc_2, this.selectionRect.x * this.ratio * 0.001 * 44100);*/
				
				//dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"_loc_3------"+_loc_3));
				
				//var _loc_5:ByteArray = WavEncoder.encode(_loc_3);
				//_controller.saveParagraph(WavEncoder.encode(_loc_3));
				//_controller.saveParagraph(AudioUtilities.encode(_loc_3)); //bala3 already saved
				try {
					_controller._loaderSaveAudio.close()
				}catch (e:Error) {
					trace(e);
				}
				var variables:Object = { };
				variables.chapter =    'ch'+_controller._currentChapter;           //"ch1";  // Modifyed by CSK..
				variables.pargraph = "p"+_controller._currentParagraph;           // "p1";   // Modifyed by CSK..
				//_urlReqSaveAudio.url = "http://127.0.0.1:8887/saveAudio.php";
				
				//   dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"variables.chapter---"+(variables.chapter)));
				//_controller._loaderSaveAudio = new URLLoader();
				_controller._urlReqSaveAudio.url = "http://rapidsoft2.dyndns.org/tantor_audio/bin-debug/save_php/upload_audio.php";
				
				// _controller._urlReqSaveAudio.data = UploadPostHelper.getPostData( "audio_c" + _controller._currentChapter + "_p" + _controller._currentParagraph + ".mp3", _mp3bytesToSaveFileOnServer, "audio", variables); //here is where the magic happens, filedata will be the name to retrieve the file // modifyed by CSK 20Feb..
				
				// Added by CSK for modifying name of audio on server for overwriting issue. on ...20Feb..
				var my_dat:Date = new Date();
				trace("Audio name for server---"+ my_dat.fullYear+""+my_dat.month+""+my_dat.date+""+my_dat.hours + "" + my_dat.minutes + "" + my_dat.seconds);
				var serverAudioFileName:Number = Number(my_dat.fullYear + "" + my_dat.month + "" + my_dat.date + "" + my_dat.hours + "" + my_dat.minutes + "" + my_dat.seconds);
				_controller._urlReqSaveAudio.data = UploadPostHelper.getPostData( serverAudioFileName + ".mp3", _mp3bytesToSaveFileOnServer, "audio", variables); //here is where the magic happens, filedata will be the name to retrieve the file
				
				//trace("_urlReqSaveAudio.data"+(_controller._urlReqSaveAudio.data));
				//_loaderSaveAudio.dataFormat = URLLoaderDataFormat.BINARY;
				_controller._loaderSaveAudio.load(_controller._urlReqSaveAudio);
			/*}//removed by oscar 07/03/13 allow saving the whole wave
			else{
				dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Selected Sound is Empty"));
				//AlertManager.createAlert(MovieClip(this.parent), "Selected Sound is Empty ", "Sound Editor", ["OK"], null, "warningIcon");
			}*/
		
		}
		
		public function cutAnwantedSound(event:MouseEvent=null):void// ********************************************************************
		{
			
			if (sound.length != 0)
			{
			selectBuffer.fillRect(selectBuffer.rect, 0);
			
			var _loc_2:* = Math.floor(this.ratio * this.selectionRect.width * 0.001 * 44100);
			var _loc_3:* = new ByteArray();
			_loc_3.endian = Endian.LITTLE_ENDIAN;
			sound.extract(_loc_3, _loc_2, this.selectionRect.x * this.ratio * 0.001 * 44100);
			
				if (_loc_3.length != 0)
				{
				//var _loc_5:* = AudioUtilities.encode(_loc_3);
				resetAllSoundObject();
				//convertWavToMp3(_loc_5)
				convertWavToMp3(_loc_3)
				}
				else
				{
					dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Play Sound then Select Audio Graph"));
					//AlertManager.createAlert(MovieClip(this.parent), "Play Sound then Select Audio Graph", "Sound Editor", ["OK"], null, "warningIcon");
				}
			}
			else
			{
				dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Import or Record Audio"));
				//AlertManager.createAlert(MovieClip(this.parent), "Import or Record Audio", "Sound Editor", ["OK"], null, "warningIcon");
			}
		
		}
		
		private function resetAllSoundObject()
		{
			if(!_addSound){//adde by Oscar 13/02/13  Allows to keep selection when overriden sound area
				selectionRect.x = 0;
				selectionRect.width = 0;
				selectBuffer.fillRect(selectBuffer.rect, 0);
			}
			playPause_mc.gotoAndStop(1)
			isSoundPlaying = false;
			cursor_mc.x = 0;
			soundPos = 0;
			stage.removeEventListener(Event.ENTER_FRAME, scrollIt);
			looper.stop();
			channel.stop();
			//channel = null;
			//channel = new SoundChannel();
			//selectBuffer.fillRect(selectBuffer.rect, 0);
		}
		
		var loadedMp3Samples:ByteArray;
		var dynamicSound:Sound;
		
		private function playSound(bytes:ByteArray):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, scrollIt);
			
			loadedMp3Samples = bytes;
			loadedMp3Samples.position = 0;
			
			dynamicSound = new Sound();
			dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			channel = dynamicSound.play();
		
		}
		
		private function onSampleData(event:SampleDataEvent):void
		{
			for (var i:int = 0; i < 4096 && loadedMp3Samples.bytesAvailable > 0; i++)
			{
				var left:Number = loadedMp3Samples.readFloat();
				var right:Number = loadedMp3Samples.readFloat();
				event.data.writeFloat(left);
				event.data.writeFloat(right);
			}
		
		}
		
		private function getExtension($url:String):String
		{
			var extension:String = $url.substring($url.lastIndexOf(".") + 1, $url.length);
			return extension;
		}
		
		//microphone code:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onMicSampleData(event:SampleDataEvent):void
		{
			updateGainMeter();
			return;
		}
		var fistTimeCapture:Boolean;
		
		public function onRecordPauseToggle(event:Event=null):void
		{
			if (!fistTimeCapture)
			{
				fistTimeCapture = true;
				capture.init();
				capture.microphone.codec = SoundCodec.NELLYMOSER;
				capture.microphone.rate = 44;
				capture.microphone.setSilenceLevel(0);
				capture.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicSampleData);
			}
			
			trace("capture.recording " + capture.recording)
			if (capture.recording)
			{
				recordTimer.stop();
				
				record_btn.gotoAndStop(1)
				isCaptureStart = false;
				stopRecording();
				/*
				if (_addSound) {//added by Oscar 12/02/13
					
					_addSound = false;
					
					////////////////////////////////////////////////////////////////////////////////
					
					var lenght:* = Math.floor(this.ratio * this.selectionRect.x * 0.001 * 44100);
					var tempData1:ByteArray = new ByteArray();
					tempData1.endian = Endian.BIG_ENDIAN;
					sound.extract(tempData1, lenght, 0);
					
					//var tempData2:ByteArray = capture.buffer;
					tempData1.writeBytes(capture.buffer);
						
					lenght = Math.floor(this.ratio * (buffer.rect.width - (this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100);
					
					var tempData3:ByteArray = new ByteArray();
					tempData3.endian = Endian.BIG_ENDIAN;
					sound.extract(tempData3, lenght, (Math.floor(this.ratio * ((this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100)));
					
					tempData1.writeBytes(tempData3);
					
					var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(tempData1));
					wevTomMp3.addEventListener("mp3Bytes", onMp3Conveted);
				
					capture.reset();
					record_btn.gotoAndStop(1);
					recordTime_txt.text = "00:00:00";
						
					timerCount = 0;
					recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
				}*/
				if (capture.buffer != null) {
					
					if (capture.buffer.length != 0) {
						
						if (_addSound) {//added by Oscar 12/02/13
					
							_addSound = false;
							
							////////////////////////////////////////////////////////////////////////////////
							
							var lenght:* = Math.floor(this.ratio * this.selectionRect.x * 0.001 * 44100);
							var tempData1:ByteArray = new ByteArray();
							tempData1.endian = Endian.BIG_ENDIAN;
							sound.extract(tempData1, lenght, 0);
							
							//var tempData2:ByteArray = capture.buffer;
							tempData1.writeBytes(capture.buffer);
								
							lenght = Math.floor(this.ratio * (buffer.rect.width - (this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100);
							
							var tempData3:ByteArray = new ByteArray();
							tempData3.endian = Endian.BIG_ENDIAN;
							sound.extract(tempData3, lenght, (Math.floor(this.ratio * ((this.selectionRect.x + this.selectionRect.width)) * 0.001 * 44100)));
							
							tempData1.writeBytes(tempData3);
							
							//var wevTomMp3:WavToMp3Bytes = new WavToMp3Bytes(AudioUtilities.encode(tempData1));
							//wevTomMp3.addEventListener("mp3Bytes", onMp3Conveted);
						
							//convertWavToMp3(AudioUtilities.encode(tempData1));
							convertWavToMp3(tempData1);
							
							//capture.reset();
							//record_btn.gotoAndStop(1);
							//recordTime_txt.text = "00:00:00";
								
							//timerCount = 0;
							//recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
						}else {
							
							//timerCount = 0;
							//recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
							//var _loc_3:ByteArray = AudioUtilities.encode(capture.buffer);  //bala2
							//convertWavToMp3(AudioUtilities.encode(capture.buffer));
							convertWavToMp3(capture.buffer);
							
							//capture.reset();
							//record_btn.gotoAndStop(1);
							//recordTime_txt.text = "00:00:00"
						}
						capture.reset();
						record_btn.gotoAndStop(1);
						recordTime_txt.text = "00:00:00";
								
						timerCount = 0;
						recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
					}
					else
					{
						dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Recorded Audio is not Valid"));
						//AlertManager.createAlert(MovieClip(this.parent), "Recorded Audio is not Valid", "Sound Editor", ["OK"], null, "warningIcon");
					}
				}
				else
				{
					dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Record Audio"));
					//AlertManager.createAlert(MovieClip(this.parent), "Record Audio", "Sound Editor", ["OK"], null, "warningIcon");
				}
			}
			else
			{
				record_btn.gotoAndStop(2)
				recordTimer.start();
				isCaptureStart = true;
				startRecording();
			}
			return;
		}
		
		/*public function saveRecordedSound(evt:MouseEvent=null)
		{
			//trace("saveRecordedSound----");
			if (capture.buffer!=null)
			{
				if (capture.buffer.length != 0)
				{
				timerCount = 0;
				recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
				var _loc_3:ByteArray = AudioUtilities.encode(capture.buffer);  //bala2
				convertWavToMp3(_loc_3);
				
				capture.reset();
				record_btn.gotoAndStop(1);
				recordTime_txt.text = "00:00:00"
				
				//var loader:URLLoader=new URLLoader();
				//var urlReq:URLRequest = new URLRequest("extract_voice.php");
  					 //urlReq.data =_loc_3;
				 	 //urlReq.method = URLRequestMethod.POST;
					 //urlReq.contentType = 'application/octet-stream';
					 //
				  //loader.dataFormat = URLLoaderDataFormat.BINARY;
				  //loader.load(urlReq);
				
				}
				else
				{
					dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Recorded Audio is not Valid"));
					//AlertManager.createAlert(MovieClip(this.parent), "Recorded Audio is not Valid", "Sound Editor", ["OK"], null, "warningIcon");
				}
			}
			else
			{
				dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Record Audio"));
				//AlertManager.createAlert(MovieClip(this.parent), "Record Audio", "Sound Editor", ["OK"], null, "warningIcon");
			}
		}*/
		
		public function onResetButton(event:Event=null):void//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WHAT EXACTLY TO DO HERE ?
		{
			if (capture.buffer != null)
			{
			capture.reset();
			timerCount = 0;
			recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
			record_btn.gotoAndStop(1);
			recordTime_txt.text = "00:00:00"
			return;
			}
			else
			{
				dispatchEvent(new SoundEditorEvent(SoundEditorEvent.Sound_Error,"Record Audio"));
				//AlertManager.createAlert(MovieClip(this.parent), "Record Audio", "Sound Editor", ["OK"], null, "warningIcon");
			}
		}
		
		private function startRecording():void
		{
			if (!capture.recording)
			{
				capture.record();
				
				if (channel)
				{
					resetAllSoundObject();
				}
				
			}
			return;
		}
		//saveRecordedSound----
		private function stopRecording():void
		{
			if (capture.recording)
			{
				capture.stop();
			}
			return;
		}
		
		private function resetBuffer():void
		{
			var _loc_1:* = capture.buffer;
			var _loc_2:* = _loc_1.position;
			_loc_1.position = 0;
			bufferBytes.clear();
			while (_loc_1.bytesAvailable)
			{
				
				bufferBytes.writeFloat(_loc_1.readFloat());
			}
			bufferBytes.position = 0;
			_loc_1.position = _loc_2;
			return;
		}
		public function stopPlayBack(evt:MouseEvent=null)
		{
			resetAllSoundObject();
		}
		private function createAudio():void
		{
			bufferBytes = new ByteArray();
			capture = new MicrophoneInput();
		}
		var recordTimer:Timer = new Timer(100);
		var timerCount:int = 0;
		
		private function updateGainMeter():void
		{
			if (capture.recording)
			{
				recordTimer.start();
				recordTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
				
				audioPan_mc.tLevelR.height = capture.microphone.activityLevel / 100 * 100;
				audioPan_mc.tLevelL.height = capture.microphone.activityLevel / 100 * 100;
			}
			
			return;
		}
		
		private function timerTickHandler(Event:TimerEvent):void
		{
			timerCount += 100;
			recordTime_txt.text = AudioUtilities.toTimeCode(timerCount);
		}
	}

}
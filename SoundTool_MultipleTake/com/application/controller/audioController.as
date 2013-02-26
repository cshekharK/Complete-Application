/**
* ...
* @author oscar - Rapidsoftsys
* Singleton Class to access data in application 
* Started Date:09 January 2013
* Last Updated Date: 22 January 2013
* 
*/
package com.application.controller {
	
	import com.application.events.ModelEvent;
	import com.application.events.SoundEditorEvent;
	import com.application.model5.ModelLocator5;
	import com.application.util.UploadPostHelper;
	import com.application.util.WavToMp3Bytes;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	public class audioController extends EventDispatcher {
		private static var _instance:audioController = null;
		
		private var _responseXML:XML;
		
		private var _fileReference:FileReference;
		
		private var _loaderCheckAudio:URLLoader = new URLLoader();
		private var _urlReqCheckAudio:URLRequest = new URLRequest();
		
		private var _audioloader:DataLoader = new DataLoader("", { name:"audio", format:"binary", onComplete:completeAudioLoad, noCache:true } );

		private var _fileExtension:String;
		
		private var _model:ModelLocator5;
		
		
		public var _currentParagraph:String = new String();
		public var _currentChapter:String = new String();
				
		public var _loaderSaveAudio:URLLoader = new URLLoader();
		public var _urlReqSaveAudio:URLRequest = new URLRequest();
		
		
		/**
		 * audioController Constructor.
		 * Type:Public Function
		 * @param ModelLocator.
		 * @return none
		 */
		public function audioController(enforcer:SingletonEnforcer) {
			if (enforcer==null) {
				throw new Error("You can only have one ModelLocator");
			}
			trace("audioController *****************************")
			_model = ModelLocator5.getInstance();
			trace("audioController **********11111111111")
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.SELECT, getLocalFile);
			
			//_urlReqSaveAudio.url = "http://rapidsoft2.dyndns.org/tantor_audio/bin-debug/save_php/upload_audio.php";
			_urlReqSaveAudio.method = URLRequestMethod.POST;
			
			_urlReqSaveAudio.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			_urlReqSaveAudio.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			_urlReqSaveAudio.requestHeaders.push( new URLRequestHeader( 'enctype', 'multipart/form-data' ) );//ADDED FOR SERVER MULTIPART
			
			_loaderSaveAudio.dataFormat = URLLoaderDataFormat.BINARY;
			
			_loaderSaveAudio.addEventListener( Event.COMPLETE, onMessageUploadedCompleted, false, 0, true );
			_loaderSaveAudio.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onMessageUploadedSecurityError, false, 0, true );
			_loaderSaveAudio.addEventListener( IOErrorEvent.IO_ERROR, onMessageUploadedIOError, false, 0, true );
			
			_loaderCheckAudio.addEventListener( Event.COMPLETE, onCheckAudioCompleted, false, 0, true );
			
			_model.addEventListener(ModelEvent.AUDIO_LIST_SELECTED, onAudioListSelected);
		}
		private function onAudioListSelected(e:ModelEvent):void {
			_audioloader.unload();
			_audioloader.url = e.data.audio;
			_audioloader.load();
		}
		private function onCheckAudioCompleted(e:Event) {
			_responseXML = XML(e.currentTarget.data);
			trace(_responseXML)
			_audioloader.unload();
			//if(_responseXML.audios.audio.length()==0){
			if(_responseXML.response.AllAudio.audios.length()==0){
				//_audioloader.unload();
				_model.dispatchEvent(new ModelEvent(ModelEvent.NO_AUDIO_ON_SERVER, null));
			}else {
				//if (_responseXML.audios.audio.length() == 1) {
				if (_responseXML.response.AllAudio.audios.length() == 1) {
					_audioloader.url = _responseXML.response.AllAudio.audios[0].audio;
					_audioloader.load();
				}else {
					//_audioloader.unload();
					var data:Object = new Object();
					data["audios"] = new Array();
					//for (var i = 0; i < _responseXML.audios.audio.length(); i++ ) {
					for (var i = 0; i < _responseXML.response.AllAudio.audios.length(); i++ ) {
						//data["audios"].push( { "date":_responseXML.audios.audio[i].@date, "audio":_responseXML.audios.audio[i] } );
						data["audios"].push( { "date":_responseXML.response.AllAudio.audios[i].@date, "audio":_responseXML.response.AllAudio.audios[i].audio } );
					}
					_model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_AUDIO_LIST, data));
				}
			}
		}
		private function completeAudioLoad(event:LoaderEvent):void {
			var binary:ByteArray = _audioloader.content;
			_model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_SOUND, {audioData:binary, extension:"mp3"}));//charges the data of the audio on the server
		}
		private function onMessageUploadedCompleted(e:Event):void {
			trace("e.currentTarget.data " + e.currentTarget.data)// ALERT IT IS RETURNING THE AUDIO FILE AGAIN - NO NEEDED I THINK, COULD USE BANDWIDTH *************************************
		}
		private function onMessageUploadedSecurityError(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
		}
        private function onMessageUploadedIOError(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
		}
		private function getLocalFile(e:Event):void {
			_fileReference.load();
			_fileReference.addEventListener(Event.COMPLETE, onfileOpenLoad);
			_fileExtension = getExtension(_fileReference.name);
		}
		private function onfileOpenLoad(ev:Event):void{
			_model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_SOUND, { audioData:_fileReference.data, extension:_fileExtension } ));//charges the data of the audio on the server
		}
		private function getExtension($url:String):String
		{
			var extension:String = $url.substring($url.lastIndexOf(".") + 1, $url.length);
			return extension;
		}
		
		//////////////////////////////////////
		
		
		public static function getInstance():audioController {
			if (_instance==null) {
				_instance=new audioController(new SingletonEnforcer() );
			}
			return _instance;
		}
		/**
		 * function To check audios for each paragraph
		 * Type:Public Function
		 * @param id for paragraph.
		 * @return none
		 */
		public function selectParagraph($chapter_Number:String, $paragraph_Number:String) {
			_currentParagraph = $paragraph_Number;
			_currentChapter = $chapter_Number;
			
			_model.dispatchEvent(new ModelEvent(ModelEvent.NEW_PARAGRAPH_SELECTED, null));
			
			//_urlReqCheckAudio.url = "http://rapidsoft2.dyndns.org/tantor_audio/bin-debug/save_php/check_audio.php?chapter=ch" + _currentChapter + "&pargraph=p" + _currentParagraph;//enable ******************
			_urlReqCheckAudio.url = "http://rapidsoft2.dyndns.org/tantor_audio/bin-debug/save_php/test_check_audio.php?chapter=ch" + _currentChapter + "&pargraph=p" + _currentParagraph;//enable ******************
			//_urlReqCheckAudio.url = "response.xml";
			_loaderCheckAudio.load(_urlReqCheckAudio);
		}
		/**
		 * function To remove audio selection
		 * Type:Public Function
		 * @return none
		 */
		public function removeAudioWave():void {
			_model.dispatchEvent(new ModelEvent(ModelEvent.REMOVE_WAVE_SELECTED, null));
		}
		/**
		 * function To ad sound to audio selection
		 * Type:Public Function
		 * @return none
		 */
		public function addAudioWave():void {
			_model.dispatchEvent(new ModelEvent(ModelEvent.ADD_WAVE_SELECTED, null));
		}
		
		/**
		 * function To save audio
		 * Type:Public Function
		 * @return none
		 */
		public function exportAudio():void {
			if (_currentParagraph != "" && _currentChapter != "" && _audioloader.content != undefined ) {
				_fileReference.save(_audioloader.content, "chapter_" + _currentChapter + "_pargraph_" + _currentParagraph + ".mp3");//MP3 Format
			}else if (_audioloader.content == undefined) {
				_model.dispatchEvent(new ModelEvent(ModelEvent.NO_AUDIO_ON_SERVER, null));
			}else {
				_model.dispatchEvent(new ModelEvent(ModelEvent.NO_PARAGRAPH_SELECTED, null));
			}
		}
		/**
		 * function To load audio locally
		 * Type:Public Function
		 * @return none
		 */
		public function importAudio():void {
			if (_currentParagraph != "" && _currentChapter != "") {
				_fileReference.browse([new FileFilter("*.wav,*.mp3 files", "*.wav;*.mp3")]);
			}else {
				_model.dispatchEvent(new ModelEvent(ModelEvent.NO_PARAGRAPH_SELECTED, null));
			}
		}
	}
}
class SingletonEnforcer {
}
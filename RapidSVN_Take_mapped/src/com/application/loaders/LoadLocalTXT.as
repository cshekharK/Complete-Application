/**
 * ...
 * @author Rapidsoftsys...
 
 * Utility class to load .txt file at runtime
 */
package com.application.loaders
{
	
	
	import com.application.util.EncodeUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class  LoadLocalTXT extends EventDispatcher
	{
		private var fileReference:FileReference;
		private var _data:String
		public static var  _fileTypeLoad:String;
		public static var FFilter:FileFilter;
		
		public function LoadLocalTXT()
		{
			selectFile();
		}
		
		private function selectFile():void
		{
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, fileSelected);
			//		fileReference.browse([new FileFilter("TXT Files (*.txt)","*.txt")]); // Commented by.CSK@Rapidsoft..on..13 Dec.	
			//Added new line for different file formet support..by.CSK@Rapidsoft..13 Dec.
			if(FFilter == null){
				fileReference.browse([ new FileFilter("Text Files (*.txt, *.rtf, *.pdf, *.doc)", 
					"*.txt;*.rtf;*.pdf;*.doc")]); 
			}else{
				trace("bala filters..")
				fileReference.browse([FFilter]);
			}
		}
		
		private function fileSelected(event:Event):void
		{
			fileReference.addEventListener(Event.COMPLETE, fileLoaded);
			fileReference.load();
		}
		public function fileLoaded(event:Event):void
		{
			_fileTypeLoad  = fileReference.type; // Added by .CSK@Rapidsoft..on..17 Dec..for saveing in same formet and name.
			var content:ByteArray = fileReference.data;
			var string:String = content.readUTFBytes(content.length);
			_data = EncodeUtil.encodeUtf8(string);
			dispatchEvent(new Event("Data_Loaded"));
			//fileReference.
		}
		
		public function get data():String 
		{
			return _data;
		}
		
		public function set data(value:String):void 
		{
			_data = value;
		}		
	}	
}
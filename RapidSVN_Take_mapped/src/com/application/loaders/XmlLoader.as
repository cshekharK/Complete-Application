/**
	 * ...
	 * @author Rapidsoftsys...
	 
	 * Utility class to load xml at runtime
	 */

package com.application.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.application.events.CustomEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * ...
	 * @author arv...
	 */
	public class XmlLoader extends EventDispatcher 
	{
		private var _xml:XML;
		private var _xmlLoader:URLLoader;
		
		
		public function XmlLoader(path:String)
		{
			
			_xmlLoader = new URLLoader();
			_xmlLoader.load(new URLRequest(path));
			_xmlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			_xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerXML);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerXML);
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXML);
			
		}
		
		private function xmlLoadCompleteHandler(evt:Event)
		{
			_xml = new XML(evt.target.data)
			dispatchEvent(new CustomEvent(CustomEvent.XML_LOADED, _xml));
			removeLoadSweepsNumXmlListeners();
		}
		
		private function httpStatusHandlerXML(e:HTTPStatusEvent):void {
		}
		private function ioErrorHandlerXML(e:IOErrorEvent=null):void {
			removeLoadSweepsNumXmlListeners();
			
		}
		private function onSecurityErrorXML(e:SecurityErrorEvent):void {
			removeLoadSweepsNumXmlListeners();
			
		}
		
		private function removeLoadSweepsNumXmlListeners():void {
			
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			_xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerXML);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerXML);
			_xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorXML);
		}
		
		
	}
	
}
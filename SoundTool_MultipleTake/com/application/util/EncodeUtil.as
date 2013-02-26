package com.application.util
{
	import flash.utils.ByteArray;
	
	/**
	 * Encode Util
	 * */
	public class EncodeUtil
	{
		/**
		 * encode UTF-8
		 * @param key
		 * 
		 * @return String
		 * */
		public static function encodeUtf8(key:String):String
		{
			var oriByteArr : ByteArray = new ByteArray();
			oriByteArr.writeUTFBytes(key);
			var tempByteArr : ByteArray = new ByteArray();
			for (var i:int = 0; i<oriByteArr.length; i++)
			{
				if (oriByteArr[i] == 194)
				{
					tempByteArr.writeByte(oriByteArr[i+1]);
					i++;
				} else if (oriByteArr[i] == 195)
				{
					tempByteArr.writeByte(oriByteArr[i+1] + 64);
					i++;
				} else
				{
					tempByteArr.writeByte(oriByteArr[i]);
				}
			}
			tempByteArr.position = 0;
			convertStringToByteArray(key);
			return tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"indian");
			//            return tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"utf-8");
		}
		
		/**
		 * decode String
		 * @param key
		 * @param charset (default = "utf-8")
		 * 
		 * @return String
		 * */
		public static function decodeString(key:String,charset:String="utf-8"):String
		{
			var result:String = "";
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(key,charset);
			byte.position = 0;
			for (var i:int; i < byte.length; i++)
			{
				//                result += escape(String.fromCharCode(byte[i]));
				result += String.fromCharCode(byte[i]);
			}
			return result;
		}
		
		/**
		 * encode String
		 * @param key
		 * @param charset (default = "utf-8")
		 * 
		 * @return String
		 * */
		public static function encodeString(key:String,charset:String = "utf-8"):String
		{
			var result:String = "";
			var byte:ByteArray = convertStringToByteArray(key);
			byte.readMultiByte(byte.bytesAvailable,charset);
			byte.position = 0;
			for (var i:int; i < byte.length; i++)
			{
				result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}
		
		/**
		 * convert String to ByteArray
		 * @param key
		 * 
		 * @return ByteArray
		 * */
		public static function convertStringToByteArray(key:String):ByteArray
		{
			var bytes:ByteArray;
			if ( key) {
				bytes = new ByteArray();
				// writeUTFBytes(value:String) let UTF-8 String write into byte stream;
				bytes.writeUTFBytes(key);
			}
			return bytes;
		}
		
		/**
		 * convert ByteArray to String
		 * @param key
		 * 
		 * @return String
		 * */
		public static function convertByteArrayToString(bytes:ByteArray):String
		{
			var str:String;
			if ( bytes ) {
				// when ByteArray convert String , please attention with bytes's position must be 0
				bytes.position = 0;
				// readUTFBytes(length:uint):read  Byte sequence at length from byte stream , and return a String;
				str = bytes.readUTFBytes(bytes.length); 
			}
			return str;
		}
		
	}
}
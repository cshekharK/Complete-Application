package com.application.util {

  import flash.display.BitmapData;
  import flash.events.EventDispatcher;
  import flash.events.Event;
  import flash.globalization.DateTimeFormatter;
  import flash.utils.*;
  import flash.geom.Rectangle;

  public class AudioUtilities 
  {
    var rect:Rectangle = new Rectangle(0, 0, 1, 0);
	var step:int;
    public static function encode( data:ByteArray ):ByteArray
		{
			var channels:uint = 2;
			var bits:uint = 32;
			var rate:uint = 44100;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeUTFBytes('RIFF');
			bytes.writeInt(uint(data.length + 44));
			bytes.writeUTFBytes('WAVE');
			bytes.writeUTFBytes('fmt ');
			bytes.writeInt(uint(32));
			bytes.writeShort(uint(1));
			bytes.writeShort(channels);
			bytes.writeInt(rate);
			bytes.writeInt(uint(rate * channels * (bits / 8)));
			bytes.writeShort(uint(channels * (bits / 8)));
			bytes.writeShort(bits);
			bytes.writeUTFBytes('data');
			bytes.writeInt(data.length);
			
			data.position = 0;
			var length:int = data.length - 4;
			while (data.position < length) { // could be better :-)
				bytes.writeShort(uint(data.readFloat() * 25536));
			}
			bytes.position = 0;
			
			return bytes;
		}
		
		public static function toTimeCode(milliseconds:int):String
		{
			var time:Date = new Date(milliseconds);
			var minutes:String = String(time.minutes);
			var seconds:String = String(time.seconds);
			var miliseconds:String = String(Math.round(time.milliseconds) / 100);
			
			minutes = (minutes.length != 2) ? '0' + minutes : minutes;
			seconds = (seconds.length != 2) ? '0' + seconds : seconds;
			miliseconds = (miliseconds.length != 2) ? '0' + miliseconds : miliseconds;
			miliseconds=String(Math.round(Number(miliseconds)))
			return String(minutes + ":" + seconds + ":" + miliseconds);
		
		}
		
		
		public  function makeGraph(byte:ByteArray,buffer:BitmapData):void
		{
		
			buffer.fillRect(buffer.rect, 0);
			byte.position = 0;
			step = byte.length / 4096;
			do
			{
				step--;
			} while (step % 4);
			
			var left:Number;
			var right:Number;
			// graph height 60
			for (var c:int = 0; c < 4096; c++)
			{
				rect.x = c / 5.3;
				left = byte.readFloat() * 90;
				
				right = byte.readFloat() * 90;
				byte.position = c * step;
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
		}
    
   
	
  }
  
}
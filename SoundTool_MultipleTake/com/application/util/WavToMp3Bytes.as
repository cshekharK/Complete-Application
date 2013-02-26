package com.application.util 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import cmodule.shine.CLibInit;
	
	
	public class WavToMp3Bytes extends EventDispatcher
	{
		private var _mp3bytes:ByteArray;
		
		private var mp3Data:ByteArray;
		private var cshine:Object;
		private var timer:Timer;
		
		
		public function WavToMp3Bytes(bytes:ByteArray)
		{
			mp3Data = new ByteArray();
			
			timer = new Timer(150);
			timer.addEventListener(TimerEvent.TIMER, update);
			
			cshine = (new cmodule.shine.CLibInit).init();
			cshine.init(this, bytes, mp3Data);
			if (timer)
			{
				timer.start();
			}
		}
	
		private function update(event:TimerEvent):void
		{
			
			try
			{
					var percent:* = cshine.update();
			}
			catch (e:Error)
			{
				trace("ShineMP3Encoder::update : cshine.update() error:" + e.message);
			}
			
			
			if (percent == 100)
			{
				try
				{
					
				}
				catch (err:Error)
				{
					
				}
				
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, update);
				timer = null;
				
				
				
						_mp3bytes=mp3Data		
						dispatchEvent(new Event("mp3Bytes"));
				
				
			}
			
			else
			{
				trace("encoding mp3...", percent + "%");
				_percent = percent;
				dispatchEvent(new Event("progress"))
			}
		}
		private var _percent:int = 0;
		public function get percentage():int 
		{
			return _percent;
		}
		
		public function get mp3bytes():ByteArray 
		{
			return _mp3bytes;
		}
		
		public function set mp3bytes(value:ByteArray):void 
		{
			_mp3bytes = value;
		}
		
		
	}
	
}
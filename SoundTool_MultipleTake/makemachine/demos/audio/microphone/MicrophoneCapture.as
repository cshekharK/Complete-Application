package makemachine.demos.audio.microphone
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	import makemachine.demos.audio.microphone.capture.*;
	import com.application.events.CustomSliderEvent
	
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	
	public class MicrophoneCapture extends Sprite
	{
		private var capture:MicrophoneInput;
		
		
		private var playing:Boolean;
		private var bufferBytes:ByteArray;
		
		public static const BUFFER_SIZE:int = 8192;
		public static const SAMPLE_RATE:int = 44100;
		private var isCaptureStart:Boolean = false;
		
		public function MicrophoneCapture()
		{
			addEventListener(Event.ENTER_FRAME, validateStage);
			
			micGainSlider_mc.value = 50;
			micGainSlider_mc.startCmp = true;
			micGainSlider_mc.addEventListener(CustomSliderEvent.ON_CHANGE, onDrag);
			saveRecord_btn.addEventListener(MouseEvent.CLICK,saveRecordedSound)
			return;
		}
		
		private function onDrag(evt:CustomSliderEvent)
		{
			if (isCaptureStart == true)
			{
				capture.microphone.gain = evt.data;
			}
		}
		
		private function validateStage(event:Event):void
		{
			if (!stage)
			{
				return;
			}
			if (!stage.stageWidth)
			{
				return;
			}
			
			removeEventListener(Event.ENTER_FRAME, validateStage);
			
			createAudio();
			createDisplay();
			
			return;
		}
		
		private function onMicSampleData(event:SampleDataEvent):void
		{
			updateGainMeter();
			return;
		}
		var fistTimeCapture:Boolean;
		private function onRecordPauseToggle(event:Event):void
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
			
			if (capture.recording)
			{
				
				recordTimer.stop();

				record_btn.gotoAndStop(1)
				isCaptureStart = false;
				stopRecording();
				
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
		
		
		private function saveRecordedSound(evt:MouseEvent)
		{
			if (capture.buffer.length > 0)
				{
				timerCount = 0;
				recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
				var _loc_3:* = MovieClip(parent).soundEdit.encode(capture.buffer);
				MovieClip(parent).soundEdit.processWavByteArray(_loc_3)
				
				
				capture.reset();
				record_btn.gotoAndStop(1);
				recordTime_txt.text="00:00:00"
				}
		}
		
		private function onResetButton(event:Event):void
		{
			capture.reset();
			timerCount = 0;
			recordTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
			record_btn.gotoAndStop(1);
			recordTime_txt.text="00:00:00"
			return;
		}
		
		private function onPlaybackSampleData(event:SampleDataEvent):void
		{
			var _loc_2:* = 0;
			var _loc_3:* = 0;
			while (_loc_2 < BUFFER_SIZE)
			{
				
				if (bufferBytes.bytesAvailable)
				{
					_loc_3 = bufferBytes.readFloat();
					event.data.writeFloat(_loc_3);
					_loc_2++;
					continue;
					continue;
				}
				break;
			}
			return;
		}
		
		private function startRecording():void
		{
			if (!capture.recording)
			{
				//recordPauseToggle.label = "Stop";
				//recordPauseToggle.selected = true;
			
				capture.record();
			}
			return;
		}
		
		private function stopRecording():void
		{
			if (capture.recording)
			{
				// recordPauseToggle.label = "Record";
				//  recordPauseToggle.selected = false;
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
		
		private function createAudio():void
		{
			
			bufferBytes = new ByteArray();
			capture = new MicrophoneInput();
			return;
		}
		
		private function createDisplay():void
		{
			record_btn.addEventListener(MouseEvent.CLICK, onRecordPauseToggle);
			reset_btn.addEventListener(MouseEvent.CLICK, onResetButton);
			
			return;
		}
		var recordTimer:Timer=new Timer(100); ;
		var timerCount:int = 0;
		private function updateGainMeter():void
		{
			if (capture.recording)
			{
				
				recordTimer.start();
				recordTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
				

				micGain_mc.tLevelR.height = capture.microphone.activityLevel / 100 * 100;
				micGain_mc.tLevelL.height = capture.microphone.activityLevel / 100 * 100;
			}
			
			return;
		}
		
		private function timerTickHandler(Event:TimerEvent):void
		{
			timerCount += 100;
			toTimeCode(timerCount);
		}
		
		private function toTimeCode(milliseconds:int)
		{
			var time:Date = new Date(milliseconds);
			var minutes:String = String(time.minutes - 30);
			var seconds:String = String(time.seconds);
			var miliseconds:String = String(Math.round(time.milliseconds) / 100);
			
			minutes = (minutes.length != 2) ? '0' + minutes : minutes;
			seconds = (seconds.length != 2) ? '0' + seconds : seconds;
			miliseconds = (miliseconds.length != 2) ? '0' + miliseconds : miliseconds;
			
			recordTime_txt.text = minutes + ":" + seconds + "." + miliseconds;
		
		}
	
	}
}

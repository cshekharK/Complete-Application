package makemachine.demos.audio.microphone.capture
{
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;

    public class MicrophoneInput extends EventDispatcher
    {
        protected var initialized:Boolean;
        protected var _buffer:ByteArray;
        protected var _mic:Microphone;
        protected var _recording:Boolean;

        public function MicrophoneInput()
        {
            return;
        }// end function

        public function get buffer() : ByteArray
        {
            return this._buffer;
        }// end function

        public function get microphone() : Microphone
        {
            return this._mic;
        }// end function

        public function get recording() : Boolean
        {
            return this._recording;
        }// end function

        public function init() : void
        {
            this.initialized = true;
            this._buffer = new ByteArray();
            this._mic = Microphone.getMicrophone();
			this._mic.codec = SoundCodec.NELLYMOSER
			this._mic .codec = SoundCodec.SPEEX //Use an enumerator class
			this._mic .encodeQuality = 10;
		    this._mic.addEventListener(SampleDataEvent.SAMPLE_DATA, this.onSampleData);
            return;
        }// end function

        public function record() : void
        {
            if (!this.initialized)
            {
                this.init();
            }
            this._recording = true;
            return;
        }// end function

        public function stop() : void
        {
            this._recording = false;
            return;
        }// end function

        public function reset() : void
        {
            this._recording = false;
            this._buffer.clear();
            return;
        }// end function

        public function close() : void
        {
            this.stop();
            this.reset();
            this._mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, this.onSampleData);
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }// end function

        protected function onSampleData(event:SampleDataEvent) : void
        {
            var _loc_2:* = NaN;
            if (this.recording)
            {
                while (event.data.bytesAvailable)
                {
                    
                    _loc_2 = event.data.readFloat();
                    this._buffer.writeFloat(_loc_2);
                    this._buffer.writeFloat(_loc_2);
                }
            }
            dispatchEvent(event);
            return;
        }// end function

    }
}

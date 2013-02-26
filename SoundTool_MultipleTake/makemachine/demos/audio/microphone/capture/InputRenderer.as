package makemachine.demos.audio.microphone.capture
{
    import __AS3__.vec.*;
    import com.bit101.components.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import makemachine.demos.audio.microphone.*;
    import makemachine.utils.*;

    public class InputRenderer extends Sprite
    {
        protected var viewport:Rectangle;
        protected var fieldContainer:Sprite;
        protected var background:Sprite;
        protected var waveform:Sprite;
        protected var xIncrement:Number;
        protected var bar:Sprite;
        protected var samples:Vector.<Number>;
        protected var startSample:int;
        protected var endSample:int;
        protected var _startTime:int;
        protected var _endTime:int;
        protected var _resolution:int;

        public function InputRenderer()
        {
            this.viewport = new Rectangle(0, 0, 0, 0);
            this.background = new Sprite();
            this.bar = new Sprite();
            this.fieldContainer = new Sprite();
            this.waveform = new Sprite();
            this.samples = new Vector.<Number>;
            this.resolution = 50;
            this.startTime = 0;
            this.endTime = 30000;
            this.setViewportSize(680, 120);
            this.renderBackground();
            addChild(this.background);
            addChild(this.waveform);
            addChild(this.bar);
            addChild(this.fieldContainer);
            return;
        }// end function

        public function get startTime() : int
        {
            return this._startTime;
        }// end function

        public function set startTime(param1:int) : void
        {
          	this._startTime = constrain(param1, 0, this._endTime);
			this.startSample = this._startTime * (MicrophoneCapture.SAMPLE_RATE / 1000);
            this.updateXIncrement();
            this.renderBackground();
            return;
        }// end function

        public function get endTime() : int
        {
            return this._endTime;
        }// end function

        public function set endTime(param1:int) : void
        {
           this._endTime = constrain(param1, this._startTime, int.MAX_VALUE);
			
            this.endSample = this._endTime * (MicrophoneCapture.SAMPLE_RATE / 1000);
            this.updateXIncrement();
            this.renderBackground();
            return;
        }// end function

        public function get resolution() : int
        {
            return this._resolution;
        }// end function

        public function set resolution(param1:int) : void
        {
            this._resolution = constrain(param1, 1, 1000);
			this.updateXIncrement();
            return;
        }// end function

        public function set viewportWidth(param1:int) : void
        {
            this.viewport.width = param1;
            this.updateXIncrement();
            this.renderBackground();
            return;
        }// end function

        public function set viewportHeight(param1:int) : void
        {
            this.viewport.height = param1;
            this.updateXIncrement();
            this.renderBackground();
            return;
        }// end function

        public function setViewportSize(param1:int=500, param2:int=100) : void
        {
            this.viewport.width = param1;
            this.viewport.height = param2;
            this.updateXIncrement();
            this.renderBackground();
            return;
        }// end function
		public function roundToInt( value:Number, round:int ):Number
		{
		return round * Math.round( ( value / round ) );
		}

        public function render(param1:ByteArray = null) : void
        {
            var _loc_6:* = NaN;
            var _loc_2:* = 0;
            var _loc_3:* = this.samples.length;
            if (param1)
            {
                param1.position = 0;
                while (param1.bytesAvailable)
                {
                    
                    this.samples[_loc_3 + _loc_2] = param1.readFloat();
                    _loc_2++;
                }
            }
            var _loc_4:* = 0;
            var _loc_5:* = this.waveform.graphics;
            this.waveform.graphics.clear();
			// color
            _loc_5.lineStyle(1, 0xF50202);
            _loc_5.moveTo(0, this.viewport.height * 0.5 + 10);
            _loc_5.lineTo(this.viewport.width, this.viewport.height * 0.5 + 10);
            _loc_5.moveTo(0, this.viewport.height * 0.5 + 10);
            if (this.samples.length > this.startSample)
            {
                _loc_2 = this.startSample;
                while (_loc_2 < this.endSample)
                {
                    
                    if (_loc_2 < this.samples.length)
                    {
                        _loc_6 = this.samples[_loc_2] * this.viewport.height + 5 + (this.viewport.height * 0.5 + 5);
                        _loc_5.lineTo(_loc_4, _loc_6);
                        _loc_4 = _loc_4 + this.xIncrement;
                    }
                    else
                    {
                        break;
                    }
                    _loc_2 = _loc_2 + this._resolution;
                }
            }
            return;
        }// end function

        public function reset() : void
        {
            this.startTime = 0;
            this.endTime = 30000;
            this.waveform.graphics.clear();
            this.samples.splice(0, this.samples.length);
            this.render();
            return;
        }// end function

        protected function renderBackground() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = NaN;
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            while (this.fieldContainer.numChildren > 0)
            {
                
                this.fieldContainer.removeChildAt(0);
            }
            var _loc_8:* = this.background.graphics;
            this.background.graphics.clear();
			// color
            _loc_8.beginFill(0xC7D2D1);
            _loc_8.drawRect(0, 0, this.viewport.width, this.viewport.height);
            _loc_8.endFill();
            _loc_8 = this.bar.graphics;
            _loc_8.clear();
			// color
            _loc_8.beginFill(0x999999);
            _loc_8.drawRect(0, 0, this.viewport.width, 20);
            _loc_8.endFill();
            _loc_4 = roundToInt(this._startTime, 1000);
            _loc_5 = roundToInt(this._endTime, 1000);
            _loc_6 = _loc_5 - _loc_4;
            _loc_7 = _loc_6 / 1000;
            _loc_8.lineStyle(1, 50943);
            _loc_1 = 0;
            while (_loc_1 < _loc_7)
            {
                
                _loc_2 = map(_loc_4 + 1000 * _loc_1, this._startTime, this._endTime, 0, this.viewport.width);
                _loc_8.moveTo(_loc_2, 1);
                _loc_8.lineTo(_loc_2, 15);
                _loc_3 = new Label(this.fieldContainer, (_loc_2 + 1), 5, String((_loc_4 + 1000 * _loc_1) / 1000));
                _loc_1++;
            }
            _loc_4 = roundToInt(this._startTime, 500);
            _loc_5 = roundToInt(this._endTime, 500);
            _loc_6 = _loc_5 - _loc_4;
            _loc_7 = _loc_6 / 500;
            _loc_8.lineStyle(1, 50943, 0.5);
            _loc_1 = 0;
            while (_loc_1 < _loc_7)
            {
                
                _loc_2 = map(_loc_4 + 500 * _loc_1, this._startTime, this._endTime, 0, this.viewport.width);
                _loc_8.moveTo(_loc_2, 1);
                _loc_8.lineTo(_loc_2, 10);
                _loc_1++;
            }
            scrollRect = this.viewport;
            return;
        }// end function

        protected function updateXIncrement() : void
        {
            this.xIncrement = this.viewport.width / ((this.endSample - this.startSample) / this._resolution);
            return;
        }// end function

    }
}

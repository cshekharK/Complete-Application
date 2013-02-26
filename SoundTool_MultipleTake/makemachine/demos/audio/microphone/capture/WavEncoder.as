package makemachine.demos.audio.microphone.capture
{
    import flash.utils.*;

    public class WavEncoder extends Object
    {

        public function WavEncoder()
        {
            return;
        }// end function

        public static function encode(param1:ByteArray) : ByteArray
        {
            var _loc_2:* = param1.position;
            param1.position = 0;
            var _loc_3:* = new ByteArray();
            _loc_3.endian = Endian.LITTLE_ENDIAN;
            while (param1.bytesAvailable)
            {
                
                _loc_3.writeShort(param1.readFloat() * 32767);
            }
            var _loc_4:* = new ByteArray();
            new ByteArray().length = 0;
            _loc_4.endian = Endian.LITTLE_ENDIAN;
            _loc_4.writeUTFBytes("RIFF");
            _loc_4.writeInt(uint(_loc_3.length + 44));
            _loc_4.writeUTFBytes("WAVE");
            _loc_4.writeUTFBytes("fmt ");
            _loc_4.writeInt(uint(16));
            _loc_4.writeShort(uint(1));
            _loc_4.writeShort(2);
            _loc_4.writeInt(44100);
            _loc_4.writeInt(uint(44100 * 2 * (16 >> 3)));
            _loc_4.writeShort(uint(2 * (16 >> 3)));
            _loc_4.writeShort(16);
            _loc_4.writeUTFBytes("data");
            _loc_4.writeInt(_loc_3.length);
            _loc_4.writeBytes(_loc_3);
            return _loc_4;
        }// end function

    }
}

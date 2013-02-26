package  {
	
	import flashx.undo.IOperation;
	import spark.components.TextArea;
	
	public class InsertOperation implements IOperation {
		
		private var previousText:String;
		private var currentText:String;
		private var textArea:TextArea;
		private var previousSelectedActive:int;
		private var previousSelectedAnchor:int;
		private var currentRange:int;
		
		public function InsertOperation(_previousText:String, _currentText:String, _textArea:TextArea, _previousSelectedActive:int, _previousSelectedAnchor:int, _currentRange:int) {
			previousText = _previousText;
			currentText = _currentText;
			textArea = _textArea;
			previousSelectedActive = _previousSelectedActive;
			previousSelectedAnchor = _previousSelectedAnchor;
			currentRange = _currentRange;
		}
		
		public function performUndo():void {
			textArea.text = previousText;
			textArea.selectRange(previousSelectedAnchor, previousSelectedActive);
		}
		
		public function performRedo():void {
			textArea.text = currentText;
			textArea.selectRange(currentRange, currentRange);
		}
	}
}
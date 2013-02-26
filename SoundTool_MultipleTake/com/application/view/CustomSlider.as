package com.application.view
{
	
	import flash.events.*;
	import flash.display.*
	import flash.geom.*;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import flash.utils.Timer;
	import com.application.events.CustomSliderEvent
	
	/**
	 * ...
	 * @author arv
	 */
	public class CustomSlider extends MovieClip 
	{
		public var rectangle:Rectangle;
		public var dragging:Boolean=true;
		public var _value:Number;
		private var _startCmp:Boolean = false;
		private var timer:Timer ;
		
			public function CustomSlider()
			{
				rectangle = new Rectangle(0, 0, sliderBar.width-mySlider_mc.width, 0);
				//mySlider_mc.x = 50;
				
				mySlider_mc.x = value;
				timer= new Timer(1);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, startSliderEvents);
				
				
			}
			private function startSliderEvents(evt:TimerEvent)
			{
			
				if (startCmp == true)
				{
				timer.stop();
				mySlider_mc.buttonMode = true;
				timer.removeEventListener(TimerEvent.TIMER, startSliderEvents);
				mySlider_mc.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
				sliderBar.addEventListener(MouseEvent.MOUSE_DOWN, easeSlider);
				}
			}
			
			private function startDragging(evt:Event) {

				
				evt.target.startDrag(false,rectangle);
				dragging = true;  
						
				mySlider_mc.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
				stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			}



			private function stopDragging(event:Event)
			{
				
				
				if (dragging)
				{
					dragging=false;
					mySlider_mc.stopDrag();
					value = Math.ceil((mySlider_mc.x /( sliderBar.width-mySlider_mc.width)) * 100);
					stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
					mySlider_mc.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
					dispatchEvent(new CustomSliderEvent(CustomSliderEvent.ON_CHANGE,value));
					
				}
			}
			
			private function easeSlider(evt:Event)
			{
				if (mouseX < mySlider_mc.width)
				{
					TweenMax.to(mySlider_mc, .5, { x:mouseX  , onComplete:onSliderEaseComplete } );
				}
				else
				{
				TweenMax.to(mySlider_mc, .5, { x:mouseX - mySlider_mc.width , onComplete:onSliderEaseComplete } );
				}
			}
			
			private function onSliderEaseComplete()
			{
				value = Math.ceil((mySlider_mc.x /( sliderBar.width-mySlider_mc.width)) * 100);
				dispatchEvent(new CustomSliderEvent(CustomSliderEvent.ON_CHANGE,value));
				
			}
						
			public function set value(val:Number):void 
			{
					_value = val;
					mySlider_mc.x=value*(sliderBar.width-mySlider_mc.width)/100;
			}
			public function get value():Number 
			{
				   return _value;
			}
			
			public function get startCmp():Boolean
			{
				return _startCmp;
			}
			
			public function set startCmp(value:Boolean)
			{
				_startCmp = value;
			}

	
		
	}
	
}
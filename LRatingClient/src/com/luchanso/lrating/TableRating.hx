package com.luchanso.lrating;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Loutchansky Oleg
 */
class TableRating extends Sprite
{
	
	static inline var font = "Arial";
	static inline var heSize = 15;
	static inline var heX = 15;	
	static inline var heHeight = 20;
	static inline var hrThickness = 20;
	
	var color:Int;
	
	public var scores:Map<Int, Score>;
	
	public var bgColor:Int;	
	public var headerText(default, set):Float;
	
	var header:TextField;

	public function new(width:Float, height:Float, headerText:String, bgColor:Int = 0xFFFFFF, color:Int = 0xFF0000, hrColor : Int = 1, alpha:Float = 1)
	{
		super();
		
		scores = new List<Score>();
		
		header = new TextField();
		header.defaultTextFormat = new TextFormat(font, heSize, color);
		header.text = "Header";
		header.autoSize = TextFieldAutoSize.LEFT;
		header.x = heX;
		header.y = heHeight / 2 - header.height / 2;
		header.selectable = false;
		header.mouseEnabled = false;
		
		this.alpha = alpha;
		this.color = color;
		
		graphics.beginFill(bgColor);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		graphics.lineStyle(hrThickness, hrColor);
		graphics.moveTo(0, heHeight);
		graphics.lineTo(width, heHeight);
		
		addChild(header);
	}
	
	public function addScore(username:String, score:String, position:Int)
	{
		scores.set(position, new Score(username, score, position));
	}
	
	function set_headerText(value:Float):Float 
	{
		return headerText = value;
	}
	
}
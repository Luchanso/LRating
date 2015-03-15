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
	
	static inline var hrThickness = 1;
	
	var colorHeader:Int;
	var colorScores:Int;
	var heHeight:Float;
	var rowHeight:Float;
	
	/**
	 * Score list
	 */
	public var scores:Map<Int, Score>;
	
	/**
	 * Background color
	 */
	public var bgColor:Int;
	/**
	 * Header text
	 */
	public var headerText(default, set):Float;
	
	var header:TextField;
	
	/**
	 * Visual table rating
	 * @param	width
	 * @param	height
	 * @param	headerText
	 * @param	bgColor - background color
	 * @param	colorHeader - header text color
	 * @param	colorScores - color rows text
	 * @param	hrColor - separrator line color
	 * @param	rowHeight
	 * @param	alpha
	 */
	public function new(width:Float, height:Float, headerText:String, bgColor:Int = 0xFFFFFF, colorHeader:Int = 0x56009D, 
						colorScores:Int = 0xEC0000,	hrColor:Int = 0xBCBCBC, rowHeight:Float = 30, alpha:Float = 1)
	{
		super();
		
		this.alpha = alpha;
		this.colorHeader = colorHeader;
		this.colorScores = colorScores;
		this.heHeight = rowHeight;
		this.rowHeight = rowHeight;
		
		scores = new Map<Int, Score>();
		
		header = new TextField();
		header.defaultTextFormat = new TextFormat(font, heSize, this.colorHeader);
		header.text = headerText;
		header.autoSize = TextFieldAutoSize.LEFT;
		header.x = heX;
		header.y = heHeight / 2 - header.height / 2;
		header.selectable = false;
		header.mouseEnabled = false;
		
		graphics.beginFill(bgColor);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		graphics.lineStyle(hrThickness, hrColor);
		graphics.moveTo(0, heHeight);
		graphics.lineTo(width, heHeight);
		
		addChild(header);
	}
	
	/**
	 * Added score in table
	 * @param	username
	 * @param	score
	 * @param	position - position in table
	 * @param	url
	 */
	public function addScore(username:String, score:String, position:Int, url:String = null)
	{
		var score = new Score(username, score, position, url);
		
		var scoreSprite = new ScoreSprite(score, width, rowHeight, 13, colorScores);
		scoreSprite.x = 0;
		scoreSprite.y = heHeight + rowHeight * Lambda.count(scores) + hrThickness;
		
		scores.set(position, score);
		
		addChild(scoreSprite);
	}
	
	function set_headerText(value:Float):Float 
	{
		return headerText = value;
	}
	
}
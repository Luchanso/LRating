package com.luchanso.lrating;


import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.net.URLRequest;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Loutchansky Oleg
 */
class ScoreSprite extends Sprite
{
	static inline var fFont = "Arial";
	static inline var paddingRL = 15;	
	static inline var margin = 5;
	static inline var hrThickness = 1;
	
	var tfPosition:TextField;
	var tfUsername:TextField;
	var tfScore:TextField;
	
	public var url:String;
	public var score:Score;

	public function new(score:Score, width:Float, height:Float, fontSize = 13, color = 0x191919, background = 0xFFFFFF, hrColor = 0xBCBCBC)
	{
		super();
		
		this.score = score;
		this.url = score.url;
		
		if (score.url != null && score.url != "")
		{		
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, urlOpen);
		}
		
		graphics.beginFill(background);
		graphics.drawRect(0, 0, width - 1, height - 1);
		graphics.endFill();
		
		graphics.lineStyle(hrThickness, hrColor);
		graphics.moveTo(0, height);
		graphics.lineTo(width, height);		
		
		tfPosition = new TextField();
		tfPosition.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfPosition.text = score.position + ")";
		tfPosition.autoSize = TextFieldAutoSize.LEFT;
		tfPosition.x = paddingRL;
		tfPosition.y = height / 2 - tfPosition.height / 2;
		tfPosition.selectable = false;
		tfPosition.mouseEnabled = false;
		
		tfUsername = new TextField();
		tfUsername.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfUsername.text = score.username;
		tfUsername.autoSize = TextFieldAutoSize.LEFT;
		tfUsername.x = tfPosition.x + tfPosition.width + margin;
		tfUsername.y = height / 2 - tfUsername.height / 2;
		tfUsername.selectable = false;
		tfUsername.mouseEnabled = false;
		
		tfScore = new TextField();
		tfScore.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfScore.text = Std.string(score.score);
		tfScore.autoSize = TextFieldAutoSize.RIGHT;
		tfScore.x = this.width - tfScore.width - paddingRL;
		tfScore.y = height / 2 - tfScore.height / 2;
		tfScore.selectable = false;
		tfScore.mouseEnabled = false;
		
		addChild(tfPosition);
		addChild(tfUsername);
		addChild(tfScore);
	}
	
	private function urlOpen(e:MouseEvent):Void 
	{
		if (url != null && url != "")
		{
			Lib.getURL(new URLRequest(url));
		}
	}
	
}
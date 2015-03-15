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
	
	var tfPosition:TextField;
	var tfUsername:TextField;
	var tfScore:TextField;
	
	var url:String;

	public function new(username:String, score:String, position:Int, width:Float, heght:Float, url:String = null, fontSize = 13, color = 0x191919, background= 0xFFFFFF, hrColor = 0xBCBCBC)
	{
		super();
		
		if (url != null)
		{		
			this.mouseEnabled = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, urlOpen);
		}
		
		this.url = url;
		
		graphics.beginFill(background);
		graphics.drawRect(0, 0, width, heght);
		graphics.endFill();
		
		tfPosition = new TextField();
		tfPosition.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfPosition.text = position + ")";
		tfPosition.autoSize = TextFieldAutoSize.LEFT;
		tfPosition.x = paddingRL;
		tfPosition.y = heght / 2 - tfPosition.height / 2;
		tfPosition.selectable = false;
		tfPosition.mouseEnabled = false;
		
		tfUsername = new TextField();
		tfUsername.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfUsername.text = position;
		tfUsername.autoSize = TextFieldAutoSize.LEFT;
		tfUsername.x = tfPosition.x + tfPosition.width + margin;
		tfUsername.y = heght / 2 - tfUsername.height / 2;
		tfUsername.selectable = false;
		tfUsername.mouseEnabled = false;
		
		tfScore = new TextField();
		tfScore.defaultTextFormat = new TextFormat(fFont, fontSize, color);
		tfScore.text = score;
		tfScore.autoSize = TextFieldAutoSize.RIGHT;
		tfScore.x = this.width - tfScore.width - paddingRL;
		tfScore.y = heght / 2 - tfScore.height / 2;
		tfScore.selectable = false;
		tfScore.mouseEnabled = false;		
		
		addChild(tfPosition);
		addChild(tfUsername);
		addChild(tfScore);
	}
	
	private function urlOpen(e:MouseEvent):Void 
	{
		Lib.getURL(new URLRequest(url));
	}
	
}
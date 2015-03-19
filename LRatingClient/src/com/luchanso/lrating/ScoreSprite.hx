package com.luchanso.lrating;


import motion.Actuate;
import motion.actuators.GenericActuator;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import openfl.geom.Matrix;
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
	static inline var paddingRL = 10;
	static inline var margin = 5;
	static inline var hrThickness = 1;
	
	var tfPosition:TextField;
	var tfUsername:TextField;
	var tfScore:TextField;
	
	var sPositionX : Float;
	var sPositionY : Float;
	
	public var url:String;
	public var score:Score;

	public function new(score:Score, width:Float, height:Float, them:Them)
	{
		super();
		
		this.alpha = 0;
		this.score = score;
		this.url = score.url;
		
		if (score.url != null && score.url != "")
		{		
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, urlOpen);
		}
		
		var matrix = new Matrix();
		matrix.createGradientBox(width, height);
		
		graphics.beginGradientFill(GradientType.LINEAR, [them.backgroundScoreColor, them.backgroundScoreColor], [1, 0], [0, 255], matrix);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		tfPosition = new TextField();
		tfPosition.defaultTextFormat = new TextFormat(fFont, 21, them.scoreColor);
		tfPosition.text = Std.string(score.position);
		tfPosition.autoSize = TextFieldAutoSize.LEFT;
		tfPosition.x = paddingRL;
		tfPosition.y = height / 2 - tfPosition.height / 2;
		tfPosition.selectable = false;
		tfPosition.mouseEnabled = false;
		
		tfUsername = new TextField();
		tfUsername.defaultTextFormat = new TextFormat(fFont, 21, them.scoreColor);
		tfUsername.text = score.username;
		tfUsername.autoSize = TextFieldAutoSize.LEFT;
		tfUsername.x = tfPosition.x + tfPosition.width + margin;
		tfUsername.y = height / 2 - tfUsername.height / 2;
		tfUsername.selectable = false;
		tfUsername.mouseEnabled = false;
		
		tfScore = new TextField();
		tfScore.defaultTextFormat = new TextFormat(fFont, 21, them.scoreColor);
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
	
	public function show() : GenericActuator<ScoreSprite>
	{
		sPositionX = this.x;
		sPositionY = this.y;
		
		this.x = sPositionX - this.width / 2;
		this.y = sPositionY - this.height / 2;
		
		return Actuate.tween(this, 1, { alpha : 1, x: sPositionX, y: sPositionY } ).autoVisible();
	}
	
	public function hide() : GenericActuator<ScoreSprite>
	{
		this.x = sPositionX;
		this.y = sPositionY;
		
		return Actuate.tween(this, 1, { alpha : 0 } ).autoVisible();
	}
	
	private function urlOpen(e:MouseEvent):Void 
	{
		if (url != null && url != "")
		{
			Lib.getURL(new URLRequest(url));
		}
	}
	
}
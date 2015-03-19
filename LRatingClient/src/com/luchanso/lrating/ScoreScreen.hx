package com.luchanso.lrating;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Loutchansky Oleg
 */
class ScoreScreen extends Sprite
{
	var scoreLabel		:TextField;
	var additionalLabel	:TextField;	
	
	public function new(additionalInfo:String = null)
	{
		super();
		
		this.alpha = 0.8;
		
		graphics.beginFill(0x0346F8);
		graphics.drawRect(0, 0, Lib.current.stage.stageWidth, height);
		graphics.endFill();
		
		scoreLabel = new TextField();
		scoreLabel.defaultTextFormat = new TextFormat("Open Sans", 50, 0xFFFFFF);
		scoreLabel.text = "";
		scoreLabel.autoSize = TextFieldAutoSize.LEFT;
		scoreLabel.x = 
		scoreLabel.selectable = false;
		scoreLabel.mouseEnabled = false;
		
		if (additionalInfo != null)
		{
			additionalLabel = new TextField();
			additionalLabel.text = additionalInfo;
		}
	}	
}
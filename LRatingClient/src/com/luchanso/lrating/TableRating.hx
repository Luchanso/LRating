package com.luchanso.lrating;

import com.luchanso.lrating.server.IServer;
import com.luchanso.lrating.TableRating.Server;
import haxe.crypto.Md5;
import haxe.remoting.AsyncProxy;
import haxe.remoting.HttpAsyncConnection;
import motion.Actuate;
import motion.easing.Bounce;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

class Server extends AsyncProxy<com.luchanso.lrating.server.IServer> {
}

/**
 * ...
 * @author Loutchansky Oleg
 */
class TableRating extends Sprite
{	
	static var alphaMax = 0.93;
	static var animationTime = .55;
	
	
	public var connectionCallback:Void -> Void;
	
	var currentWidth = Lib.current.stage.stageWidth;
	var currentHeight = Lib.current.stage.stageHeight;
	
	var api 		:Server;
	var serverHash 	:String;
	var serverKey 	:String;
	var privateKey	:String;
	
	var gameName	:String;
	var them		:Them;
	
	public var scores:Map<Int, Score>;
	public var scoreSprites:List<ScoreSprite>;
	
	var header	:TextField;
	var info 	:TextField;
	
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
	public function new(gameName:String, fontName:String = "Arial", them:Them = null)
	{
		super();
		
		if (them == null)
			this.them = them = new BlueThem();			
		else
			this.them = them;
		
		
		this.gameName = gameName;
		this.alpha = 0;
		this.visible = false;
		
		scores = new Map<Int, Score>();
		scoreSprites = new List<ScoreSprite>();
		
		graphics.beginFill(them.backgroundTableColor);
		graphics.drawRect(0, 0, currentWidth, currentHeight);
		graphics.endFill();
		
		header = new TextField();
		header.defaultTextFormat = new TextFormat(fontName, 30, them.tableColor);
		header.text = "Рейтинг";
		header.autoSize = TextFieldAutoSize.LEFT;
		header.x = currentWidth / 2 - header.width / 2;
		header.y = 0;
		header.selectable = false;
		header.mouseEnabled = false;
		
		info = new TextField();
		info.defaultTextFormat = new TextFormat(fontName, 25, them.tableColor);
		info.text = "Нажмите пробел, чтобы продолжить";
		info.autoSize = TextFieldAutoSize.LEFT;
		info.x = currentWidth / 2 - info.width / 2;
		info.y = currentHeight - info.height - 5;
		info.selectable = false;
		info.mouseEnabled = false;
		
		addChild(header);
		addChild(info);
	}
	
	private function keyDown(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.SPACE)
		{
			this.hide();
			this.dispatchEvent(new LRatingEvent(LRatingEvent.TABLE_CLOSE));
		}
	}
	
	public function hide()
	{
		var isCancel = this.dispatchEvent(new LRatingEvent(LRatingEvent.TABLE_HIDE, false, true));
		
		if (isCancel)
		{
			Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);			
			
			var i = 0;
			for (sprite in scoreSprites)
			{				
				sprite.hide().delay(i/1000 * 25);
				i++;
			}			
			
			Actuate.tween(this, animationTime, { alpha: 0 } ).autoVisible().delay((currentHeight / 50)/1000 * 25);
		}
	}
	
	public function show()
	{
		var isCancel = this.dispatchEvent(new LRatingEvent(LRatingEvent.TABLE_SHOW, false, true));
		
		if (isCancel)
		{			
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			//this.visible = true;
			Actuate.tween(this, animationTime, { alpha: alphaMax } ).autoVisible();
			
			var i = 0;
			for (sprite in scoreSprites)
			{
				sprite.show().delay(animationTime + i/1000 * 50);
				i++;
			}
		}
	}
	
	private function mouseMove(e:MouseEvent):Void 
	{
		/*if (e.localY < rowHeight * 2)
		{
			
		}
		else if (e.localY > this.height - rowHeight * 2)
		{
			
		}*/
	}
	
	/**
	 * Added score in table
	 * @param	username
	 * @param	score
	 * @param	position - position in table
	 * @param	url
	 */
	public function addScore(username:String, score:Float, position:Int, url:String = null)
	{		
		var score = new Score(username, score, position, url);
		
		var scoreSprite = new ScoreSprite(score, currentWidth - currentWidth / 3, 50, them);
		scoreSprite.x = currentWidth / 2 - scoreSprite.width / 2;		
		scoreSprite.y = 50 + scoreSprite.height * Lambda.count(scores) + 5;
		
		scoreSprites.add(scoreSprite);
		
		scores.set(position, score);
		
		addChild(scoreSprite);
		
		if (this.visible)
			scoreSprite.show();
	}
	
	public function addToServer(score:Score)
	{
		api.newRecord(score, gameName, Md5.encode(privateKey + serverHash + serverKey), serverHash, serverKey, finishAdd);
	}
	
	function finishAdd(result:Bool)
	{
	}
	
	public function checkExistToTop(score:Float):Bool
	{
		for (s in scores)
		{
			if (s.score < score)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function connectToServer(url:String, privateKey:String)
	{
		this.privateKey = privateKey;
		
		var a = HttpAsyncConnection.urlConnect(url);
		var scnx = a.resolve("server");
		api = new Server(scnx);
		
		api.getServerData(getServerData);
	}
	
	public function getDataFromServer()
	{
		api.getTableRecords(gameName, addMapScore);
	}
	
	function addMapScore(map:Map<Int, Score>)
	{
		for (score in map)
		{
			addScore(score.username, score.score, score.position, score.url);
		}
	}
	
	function getServerData(data:Dynamic) 
	{
		this.serverKey = data.serverKey;
		this.serverHash = data.serverHash;
		
		connectionCallback();
	}
	
}
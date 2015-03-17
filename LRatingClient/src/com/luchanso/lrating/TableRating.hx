package com.luchanso.lrating;

import com.luchanso.lrating.server.IServer;
import com.luchanso.lrating.TableRating.Server;
import haxe.crypto.Md5;
import haxe.remoting.AsyncProxy;
import haxe.remoting.HttpAsyncConnection;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class Server extends AsyncProxy<com.luchanso.lrating.server.IServer> {
}

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
	
	public var connectionCallback:Void -> Void;
	
	var api 		:Server;
	var serverHash 	:String;
	var serverKey 	:String;
	var privateKey	:String;
	
	var colorHeader	:Int;
	var colorScores	:Int;
	var heHeight	:Float;
	var rowHeight	:Float;
	
	var gameName	:String;
	
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
	public function new(gameName:String, width:Float, height:Float, headerText:String, bgColor:Int = 0xFFFFFF, colorHeader:Int = 0x56009D, 
						colorScores:Int = 0xEC0000,	hrColor:Int = 0xBCBCBC, rowHeight:Float = 30, alpha:Float = 1)
	{
		super();
		
		this.gameName = gameName;
		
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
		graphics.drawRect(0, 0, width, rowHeight - 1);
		graphics.endFill();
		
		graphics.lineStyle(hrThickness, hrColor);
		graphics.moveTo(0, heHeight);
		graphics.lineTo(width, heHeight);
		
		addChild(header);
		
		this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
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
		
		
		var scoreSprite = new ScoreSprite(score, width - 1, rowHeight, 13, colorScores);
		scoreSprite.x = 0;
		scoreSprite.y = heHeight + rowHeight * Lambda.count(scores) + hrThickness;		
		
		scores.set(position, score);
		
		addChild(scoreSprite);
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
	
	function set_headerText(value:Float):Float 
	{
		return headerText = value;
	}
	
}
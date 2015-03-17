package com.luchanso.lrating;

import com.luchanso.lrating.basedate.BdScore;
import com.luchanso.lrating.IServer;
import com.luchanso.lrating.Score;
import haxe.crypto.Md5;
import haxe.Json;
import sys.db.Manager;
import sys.io.File;

/**
 * ...
 * @author Loutchansky Oleg
 */
class Server implements IServer
{
	var config : Dynamic;
	var keyNow : String;

	public function new() 
	{
		config = Json.parse(File.getContent("config/config.json"));
		keyNow = Md5.encode(Date.now().toString() + config.keySalt);
		
		var cnx = sys.db.Mysql.connect({
			host : config.bd.host,
			port : null,
			user : config.bd.user,
			pass : config.bd.pass,
			database : config.bd.database,
			socket : null,
		});
		cnx.request("SET NAMES utf8");
		sys.db.Manager.cnx = cnx;
		if ( !sys.db.TableCreate.exists(BdScore.manager) )
		{
			sys.db.TableCreate.create(BdScore.manager);
		}
		
		sys.db.Manager.initialize();		

	}
	
	/* INTERFACE com.luchanso.lrating.IServer */
	
	public function newRecord(score:Score, game:String, hashSumm:String, serverHash:String, serverKey:String):Bool
	{
		if (Md5.encode(config.privateKey + serverKey) != serverHash)
		{			
			throw("Bad security 101");
		}
			
		if (Md5.encode(config.privateClientKey + serverHash + serverKey) != hashSumm)
			throw("Bad security 102");
			
		if (score.username.length > 64)
			throw("Username is very long (max 64 symbols)");
			
		if (score.url != null)
		{
			if (score.url.length > 64)
				throw("Url is very long (max 64 symbols)");
		}
		
		var bdScore = new BdScore();
		bdScore.userName = score.username;
		bdScore.url = score.url;
		bdScore.score = score.score;
		bdScore.insert();
		
		reCalcBaseDate();
			
		return true;
	}
	
	function reCalcBaseDate()
	{
		var tableSize = cast (config.tableSize, Int);
		if (BdScore.manager.count(true) > config.tableSize)	
			BdScore.manager.delete(true, { orderBy : -score, limit : [tableSize, 1] } );
	}
	
	public function getTableRecords(game:String):Map<Int, Score>
	{
		var scores = new Map<Int, Score>();
		var position = 0;
		var tableSize = cast (config.tableSize, Int);
		
		for (s in BdScore.manager.search(true, { orderBy : -score, limit : tableSize }, true))
		{
			position++;
			scores.set(position, new Score(s.userName, s.score, position, s.url));
		}
		
		return scores;
	}
	
	public function getServerData():Dynamic
	{
		return { serverKey: keyNow, serverHash: Md5.encode(config.privateKey + keyNow) };
	}
	
}
package com.luchanso.lrating;

import com.luchanso.lrating.Score;

/**
 * @author Loutchansky Oleg
 */

interface IServer 
{
	public function newRecord(score:Score, game:String, hashSumm:String, serverHash:String, serverKey:String):Bool;
	public function getTableRecords(game:String):Map<Int, Score>;
	public function getServerData():Dynamic;
}
package com.luchanso.lrating;

/**
 * ...
 * @author Loutchansky Oleg
 */
class Score
{
	public var username:String;
	public var score:String;
	public var position:Int;

	public function new(?username:String, ?score:String, ?position:Int)
	{
		this.position = position;
		this.score = score;
		this.username = username;
	}
	
}
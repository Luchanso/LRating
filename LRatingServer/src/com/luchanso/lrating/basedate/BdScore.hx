package com.luchanso.lrating.basedate;

import sys.db.Object;
import sys.db.Types.SId;
import sys.db.Types.SString;

/**
 * ...
 * @author Loutchansky Oleg
 */
@:table("scores")
class BdScore extends Object
{
	public var id 		:SId;
	public var userName :SString<64>;
	public var score 	:Float;
	public var url 		:SString<64>;

	public function new()
	{
		super();
		
	}
	
	public static var manager = new sys.db.Manager<BdScore>(BdScore);
}
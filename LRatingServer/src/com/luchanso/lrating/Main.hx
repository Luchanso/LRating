package com.luchanso.lrating;

import com.luchanso.lrating.Server;
import haxe.remoting.Context;
import haxe.remoting.HttpAsyncConnection;
import haxe.remoting.HttpConnection;
import php.Lib;

/**
 * ...
 * @author Loutchansky Oleg
 */

class Main
{

	static function main() 
	{
		var cnx = new Context();
		cnx.addObject("server", new Server());
		HttpConnection.handleRequest(cnx);		
	}

}
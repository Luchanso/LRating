<?php

class com_luchanso_lrating_Main {
	public function __construct(){}
	static function main() {
		php_Lib::hprint("Bad idea, my school friend. You have 2 chances, then you will be banned.");
		$cnx = new haxe_remoting_Context();
		$cnx->addObject("server", new com_luchanso_lrating_Server(), null);
		haxe_remoting_HttpConnection::handleRequest($cnx);
	}
	function __toString() { return 'com.luchanso.lrating.Main'; }
}

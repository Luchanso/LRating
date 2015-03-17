<?php

class com_luchanso_lrating_Main {
	public function __construct(){}
	static function main() {
		$cnx = new haxe_remoting_Context();
		$cnx->addObject("server", new com_luchanso_lrating_Server(), null);
		haxe_remoting_HttpConnection::handleRequest($cnx);
	}
	function __toString() { return 'com.luchanso.lrating.Main'; }
}

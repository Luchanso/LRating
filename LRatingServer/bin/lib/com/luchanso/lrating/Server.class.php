<?php

class com_luchanso_lrating_Server implements com_luchanso_lrating_IServer{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		{
			$text = sys_io_File::getContent("config/config.json");
			$this->config = haxe_Json::phpJsonDecode($text);
		}
		$this->keyNow = haxe_crypto_Md5::encode(_hx_string_or_null(Date::now()->toString()) . Std::string($this->config->keySalt));
		$cnx = sys_db_Mysql::connect(_hx_anonymous(array("host" => $this->config->bd->host, "port" => null, "user" => $this->config->bd->user, "pass" => $this->config->bd->pass, "database" => $this->config->bd->database, "socket" => null)));
		$cnx->request("SET NAMES utf8");
		sys_db_Manager::set_cnx($cnx);
		if(!sys_db_TableCreate::exists(com_luchanso_lrating_basedate_BdScore::$manager)) {
			sys_db_TableCreate::create(com_luchanso_lrating_basedate_BdScore::$manager, null);
		}
		sys_db_Manager::initialize();
	}}
	public $config;
	public $keyNow;
	public function newRecord($score, $game, $hashSumm, $serverHash, $serverKey) {
		if(haxe_crypto_Md5::encode(Std::string($this->config->privateKey) . _hx_string_or_null($serverKey)) !== $serverHash) {
			throw new HException("Bad security");
		}
		if(haxe_crypto_Md5::encode(Std::string($this->config->privateClientKey) . _hx_string_or_null($serverHash) . _hx_string_or_null($serverKey)) !== $hashSumm) {
			throw new HException("Bad security");
		}
		if(strlen($score->username) > 64) {
			throw new HException("Username is very long (max 64 symbols)");
		}
		if($score->url !== null) {
			if(strlen($score->url) > 64) {
				throw new HException("Url is very long (max 64 symbols)");
			}
		}
		$bdScore = new com_luchanso_lrating_basedate_BdScore();
		$bdScore->userName = $score->username;
		$bdScore->url = $score->url;
		$bdScore->score = $score->score;
		$bdScore->insert();
		$this->reCalcBaseDate();
		return true;
	}
	public function reCalcBaseDate() {
		$tableSize = null;
		$tableSize = $this->config->tableSize;
		com_luchanso_lrating_basedate_BdScore::$manager->unsafeDelete("DELETE FROM scores WHERE 1 ORDER BY score DESC LIMIT " . _hx_string_or_null(sys_db_Manager::quoteAny($tableSize)) . ",1");
	}
	public function getTableRecords($game) {
		$scores = new haxe_ds_IntMap();
		$position = 0;
		$tableSize = null;
		$tableSize = $this->config->tableSize;
		if(null == com_luchanso_lrating_basedate_BdScore::$manager->unsafeObjects("SELECT * FROM scores WHERE 1 ORDER BY score DESC LIMIT " . _hx_string_or_null(sys_db_Manager::quoteAny($tableSize)), true)) throw new HException('null iterable');
		$__hx__it = com_luchanso_lrating_basedate_BdScore::$manager->unsafeObjects("SELECT * FROM scores WHERE 1 ORDER BY score DESC LIMIT " . _hx_string_or_null(sys_db_Manager::quoteAny($tableSize)), true)->iterator();
		while($__hx__it->hasNext()) {
			$s = $__hx__it->next();
			$position++;
			{
				$value = new com_luchanso_lrating_Score($s->userName, $s->score, $position, $s->url);
				$scores->set($position, $value);
				unset($value);
			}
		}
		return $scores;
	}
	public function getServerHash() {
		return haxe_crypto_Md5::encode(Std::string($this->config->privateKey) . _hx_string_or_null($this->keyNow));
	}
	public function getServerKey() {
		return $this->keyNow;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'com.luchanso.lrating.Server'; }
}

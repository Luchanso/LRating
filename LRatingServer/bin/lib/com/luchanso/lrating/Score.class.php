<?php

class com_luchanso_lrating_Score {
	public function __construct($username = null, $score = null, $position = null, $url = null) {
		if(!php_Boot::$skip_constructor) {
		$this->position = $position;
		$this->score = $score;
		$this->username = $username;
		$this->url = $url;
	}}
	public $username;
	public $score;
	public $position;
	public $url;
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
	function __toString() { return 'com.luchanso.lrating.Score'; }
}

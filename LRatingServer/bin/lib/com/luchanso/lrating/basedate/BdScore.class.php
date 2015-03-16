<?php

class com_luchanso_lrating_basedate_BdScore extends sys_db_Object {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public $id;
	public $userName;
	public $score;
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
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	static $manager;
	function __toString() { return 'com.luchanso.lrating.basedate.BdScore'; }
}
com_luchanso_lrating_basedate_BdScore::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => (new _hx_array(array("oy4:namey6:scoresy7:indexesahy9:relationsahy7:hfieldsby8:userNameoR0R5y6:isNullfy1:tjy17:sys.db.RecordType:9:1i64gy3:urloR0R9R6fR7jR8:9:1i64gy2:idoR0R10R6fR7jR8:0:0gy5:scoreoR0R11R6fR7jR8:7:0ghy3:keyaR10hy6:fieldsar8r4r10r6hg")))))));
com_luchanso_lrating_basedate_BdScore::$manager = new sys_db_Manager(_hx_qtype("com.luchanso.lrating.basedate.BdScore"));

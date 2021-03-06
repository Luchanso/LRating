<?php

class Lambda {
	public function __construct(){}
	static function map($it, $f) {
		$l = new HList();
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			$l->add(call_user_func_array($f, array($x)));
		}
		return $l;
	}
	function __toString() { return 'Lambda'; }
}

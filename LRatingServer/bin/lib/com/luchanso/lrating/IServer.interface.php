<?php

interface com_luchanso_lrating_IServer {
	function newRecord($score, $game, $hashSumm, $serverHash, $serverKey);
	function getTableRecords($game);
	function getServerData();
}

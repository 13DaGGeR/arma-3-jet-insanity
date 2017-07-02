// server
if (!isServer) exitWith {};

players=[];//name,lvl,uid
publicVariable 'FPS';

handleKilled = compile preprocessFile "scripts\frag.sqf"; //_v,_type
spawnEnemy = compile preprocessfilelinenumbers "scripts\spawnEnemy.sqf";


scoreBoardUpd={
	private['_arr'];
	_arr=[players,[],{(_x select 1)*1000+(_x select 4);},"DESCEND"] call BIS_fnc_sortBy;
	_arr resize ((count _arr) min 10);
	scoreArr=[];
	{
		scoreArr=scoreArr+[[
			_x select 0,
			str(_x select 4),
			str((_x select 1)+1)
		]];
	}foreach (_arr);
	publicVariable 'scoreArr';
};

playerConnected={
	params["_player"];
	//name, lvl,uid,owner,kills
	players pushBack [_player getVariable['pname','-user-'],0,getPlayerUID _player,owner _player,0];
	call scoreBoardUpd;
};
onPlayerDisconnected {
	params["_id","_uid","_name"];
	{
		scopeName "for";
		if ((_x select 2)==_uid) then{
			players set [_forEachIndex,-1];
			players=players-[-1];
			breakOut "for";
		};
	}foreach (players);
	call scoreBoardUpd;
};

updateLvl={
	params["_uid","_lvl"];
	{
		scopeName "for";
		if ((_x select 2)==_uid) then{
			_x set [1,_lvl];
			players set [_forEachIndex,_x];
			breakOut "for";
		};
	}foreach (players);

	if(currentLvl<_lvl) then{
		currentLvl=_lvl;
		publicVariable "currentLvl";
	};

	call scoreBoardUpd;
};

[] call spawnEnemy;

[] spawn {
	while {true} do{
		FPS=round diag_fps;
		publicVariable 'FPS';
		sleep 1;
	};
}

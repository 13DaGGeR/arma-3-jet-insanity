//Count a frag
params ["_vehicle","_type"];

_vehicle addEventHandler["handleDamage",{
	params["_v","_noNeed","_dmg","_damager"];
	private ['_n',"_uid","_damagers","_damages","_tmp"];
	_uid=getPlayerUID _damager;
	if((_dmg>0) && (_uid!="")) then {
		//_n=(configFile>>"CfgVehicles">>(typeOf _v)>>"displayName") call BIS_fnc_getCfgData;
		_damagers=_v getVariable ["damagers", []];
		_damages=_v getVariable ["damages", []];
		if (_uid in _damagers) then{
			_tmp=_damagers find _uid;
			_damages set [_tmp,(_damages select _tmp) + _dmg];
		}else{
			//format["%2: New damager: %1",_uid,_n] remoteExec ["systemChat"];
			_tmp=count _damagers;
			_damagers set [_tmp, _uid];
			_damages set [_tmp, _dmg];
		};
		_v setVariable["damagers",_damagers,true];
		_v setVariable["damages",_damages,true];
	};
}];

_vehicle addEventHandler["killed",{
	params ["_v","_killer"];
	_killer=driver _killer;

	//_n=(configFile>>"CfgVehicles">>(typeOf _v)>>"displayName") call BIS_fnc_getCfgData;
	//format["%2 killed by %1(%3)",_killer,_n,getPlayerUID _killer] remoteExec ["systemChat"];

	if(!(_killer in allPlayers)) then{
		_killer=[_v] call fragFindKiller;
	};

	if(_killer in allPlayers) then{
		[_v,_killer] remoteExec ["fragCli",owner _killer];
		[getPlayerUID _killer] call incrKillsInScore;
	};
    eAlive=eAlive-1;
	publicVariable "eAlive";
	if (_type==0) then {eJetsAlive=eJetsAlive-1;publicVariable "eJetsAlive";};
    _v removeAllEventHandlers "killed";
	_v removeAllEventHandlers "GetOut";
	_v removeAllEventHandlers "handleDamage";
	[_v] spawn{
		params["_v"];
		sleep secondsBeforeDespawn;
		{
			deleteVehicle _x;
		}forEach crew _v;
		deleteVehicle _v;
	};
    [] call spawnEnemy;
}];


//handle empty vehicle (crew killed or run)
[_vehicle] spawn {
	params["_v"];
	//_n=(configFile>>"CfgVehicles">>(typeOf _v)>>"displayName") call BIS_fnc_getCfgData;

	while {alive _v} do {
		sleep 10;//check every 10 sec
		//format["%2: check crew",_uid,_n] remoteExec ["systemChat"];
		if({alive _x} count (crew _v) == 0 && (alive _v))then{
			sleep 5;
			_v setDamage 0.99;
		};
	};
};

_n=(configFile>>"CfgVehicles">>(typeOf _vehicle)>>"displayName") call BIS_fnc_getCfgData;

fragFindKiller={
	params["_v"];
	private ["_damagers","_uid","_killer"];
	_damagers=_v getVariable["damagers",[]];
	call{
		if((count _damagers)<1)exitWith{_uid=nil;};
		if((count _damagers)>1)then{
			private ["_damages","_max"];
			_damages=_v getVariable["damages",[]];
			_max=0;
			{
				_max=_max max _x;
			}foreach _damages;
			_uid=_damagers select (_damages find _max);
		}else{
			_uid=_damagers select 0;
		};
		_uid;
	};
	
	_killer=_nil;//server;
	{
		if(_uid==(getPlayerUID _x)) exitWith {_killer=_x;}; 
	}foreach allPlayers;

	//format["FFK: damagers:%1 uid:%2 killer:%3",str(_damagers),_uid,_killer] remoteExec ["systemChat"];
	
	_killer;
};

pvpKill={
	params ["_victim","_killer"];
	diag_log format ["debug#1: pvpKill: %1 killed by %2", _victim, _killer];
	diag_log format ["debug#1: pvpKill: %1 killed by (driver) %2", _victim, _killer];
	if(_killer in allPlayers) then{
		diag_log format ["debug#1:%1 is in allPlayers", _killer];
		diag_log format ["debug#1:%1 's uid is %2", _killer,getPlayerUID _killer];
		[_victim,_killer] remoteExec ["fragCli",owner _killer];
		[getPlayerUID _killer] call incrKillsInScore;
		//[[_victim,_killer],"fragCli",owner _killer,false,true] call BIS_fnc_MP;
	};
};

incrKillsInScore={
	params['_uid'];
	{
		scopeName "for";
		if ((_x select 2)==_uid) then{
			_x set [4,(_x select 4)+1];
			players set [_forEachIndex,_x];
			breakOut "for";
		};
	}foreach (players);
	call scoreBoardUpd;
};


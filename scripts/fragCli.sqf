//count frag on killer's cli
if(isDedicated) exitWith {};
private["_kills","_killsLeft","_lvl","_msg"];
params["_v","_killer"];

if(_killer!=player) exitWith {};

_kills=player getVariable["kills",0];
_kills=_kills+1;
player setVariable["kills",_kills,true];

_killsLeft=player getVariable "killsLeft";
_killsLeft=_killsLeft - 1;

[_v] call fragOmatic;
_msg=format["%1 destroyed<br />",(configFile>>"CfgVehicles">>typeOf _v>>"displayName") call BIS_fnc_getCfgData];

if(_killsLeft<=0)then [{ //lvl up !!!!!!!
	_lvl=player getVariable["lvl",0];
	_lvl=_lvl+1;
	player setVariable["lvl",_lvl,true];
	_killsLeft=lvlEvery;
	_msg=_msg+"<t color='#ff00000'>Level UP!</t><br />";
	[getPlayerUID player,_lvl] remoteExecCall ["updateLvl",2];
	[] remoteExecCall ["scoreBoardText",2];
	plane=[true] call getPlane;
	playSound "lvlup";
},{
	_msg=_msg+format["%1 kills left to level UP<br />",_killsLeft];
	_msg=[lvlEvery-_killsLeft,_msg] call rearmPlane;
	_msg=[lvlEvery-_killsLeft,_msg] call repairPlane;
	playSound (["f1","f2","f3"] call BIS_fnc_selectRandom);
}];
player setVariable["killsLeft",_killsLeft,true];


if ((player getVariable["lvl",0])>=maxLvl) then {
	["end1",false] remoteExecCall ["BIS_fnc_endMission",(owner player)*-1];
	["end1",true] call BIS_fnc_endMission;
};

hint parseText _msg;
call updateInfo;


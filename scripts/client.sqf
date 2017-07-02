//client 

if(isDedicated) exitWith {};
waitUntil {!isNull player};
player setVariable['pname',profileName,true];
player addRating -10000; //deathmatch!!
player remoteExecCall ["playerConnected",2];

getPlane = compile preprocessfilelinenumbers "scripts\getPlane.sqf";
fragCli = compile preprocessfilelinenumbers "scripts\fragCli.sqf";
fragCam="camera" camCreate [0,0,0];
cutRsc["InfoBoard","PLAIN"];

waitUntil {!isNull(findDisplay 46)}; 
(findDisplay 46) displaySetEventHandler ["KeyDown","_this call myHandleKeyDown"];
myHandleKeyDown={
	params['_source','_keyCode','_isShift','_isCtrl','_isAlt'];
	private['_handled'];
	_handled = false;
	if !(_isCtrl || _isShift || _isAlt) then {
		switch (_keyCode) do {
			case 25:{//P key
				[] spawn toggleScore;
				_handled = true;
			};
		};
	};
	_handled;
};
scoreShown=true;
toggleScore={
	if (scoreShown) then{
		scoreShown=false;
		closeDialog 782;
	}else{
		scoreShown=true;
		createDialog "Score";
		lnbClear 782;
		lnbAddRow[782,[
			"Player",
			"Kills",
			"Level"
		]];
		{
			lnbAddRow[782,_x];
		}foreach (scoreArr);
	};
};


lameRearm={
	private["_timer"];
	player setVariable["killsLeft",lvlEvery,true];
	
	for "_i" from 0 to lameRearmDelay do{
		hint format ['%1 sec left for new plane',lameRearmDelay-_i];
		UISleep 1;
	};
	
	player setDamage 0;
	plane=[true] call getPlane;
	call updateInfo;
	[] remoteExecCall ["scoreBoardUpd",2];
};

updateInfo={
	_txt="<t align='left'>Level</t>"+
			format["<t align='right' color='#00ff00' size='2'>%1</t><br />",(player getVariable["lvl",0])+1]+
			"<t align='left'>Kills for next level</t>"+
			format["<t align='right' color='#ff0000'>%1</t><br />",(player getVariable["killsLeft",lvlEvery])]+
			"<t align='left'>Enemy presence</t>"+
			format["<t align='right' color='#ffffff'>%1</t><br />",eAlive + (count scoreArr) - 1]+
			"<t align='left'>AI Level</t>"+
			format["<t align='right' color='#ffffff'>%1</t><br />",currentLvl+1];//*/
	((uiNamespace getVariable "TAG_InfoBoard") displayCtrl 700) ctrlSetStructuredText parseText _txt;
};


fragOmatic={
	params ["_v"];
	private ["_ang","_dist","_pos"];
	_ang=floor(random 360);
	_dist=30;
	_pos=getPos _v;
	_pos=[
		(_pos select 0) + _dist*(sin _ang),
		(_pos select 1) + _dist*(cos _ang),
		(_pos select 2) + _dist
	];
	fragCam = "camera" camCreate _pos;
	fragCam camPrepareTarget _v;
	fragCam camCommitPrepared 0;
	fragCam cameraEffect ["INTERNAL", "BACK"];fragCam camCommit 0;
	fragCam cameraEffect ["INTERNAL", "BACK", "fragrender"];
	fragCam camCommit 1;
	[] spawn {uiSleep 5; call fragOmaticStop;};
};

fragOmaticStop={
	if(typeOf fragCam == 'camera')then{
		fragCam cameraEffect ["Terminate","BACK"];
		fragCam camCommit 0;
		camDestroy fragCam;
	};
};
call fragOmaticStop;

player addEventHandler["Respawn",{
	setPlayerRespawnTime respawnDelay;
	[] spawn {
		sleep 3;
		cutRsc["InfoBoard","PLAIN"];
		//player addAction [format ["Fix and rearm - wipe current level progress(%1 sec)",lameRearmDelay], {[] spawn lameRearm;}];
		call updateInfo;
		private["_title"]; _title="<t color='#aaaaaa' align='right'>Jet Insanity by 13dagger v"+JIVersion+"</t>";
		((uiNamespace getVariable "TAG_InfoBoard") displayCtrl 730) ctrlSetStructuredText parseText _title;
		call fragOmaticStop;
	};

	plane=[false] call getPlane;
	plane addRating -10000;
	player setVariable["killsLeft",lvlEvery,true];
	[] remoteExecCall ["scoreBoardUpd",2];
}];

player addEventHandler["Killed",{
	params ["_victim","_killer"];
	_killer=driver _killer;
	if((_killer in allPlayers) && (_killer!=_victim)) then{
		[_victim,_killer] remoteExecCall ["pvpKill",2];
	};
}];

[] spawn {
	private ['_msg'];
	while {true} do {
		_msg=if (FPS>0) then[{format["<t color='#cccccc' align='left'>ServerFPS %1</t>",FPS]},{''}];
		((uiNamespace getVariable "TAG_InfoBoard") displayCtrl 735) ctrlSetStructuredText parseText _msg;
		sleep 1;
	};
};

forceRespawn player;

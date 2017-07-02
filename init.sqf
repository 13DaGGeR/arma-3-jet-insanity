/*
-intro

-give more kills on pvp kill (give all skipped ammo for it?)
-redefine key for score

set players hostile

*/
HASH={
	params ["_string"]; private ["_hash", "_i","_len","_max"];
	_len=4; 
	_max=(10^(_len-1)) - 1; 
	_hash=0; 
	_i=0; 
	{ 
		_hash=_hash+(_x*(10^_i)); 
		_i=_i+1; 
		if(_hash>_max)then{ 
		_hash=_hash-_max; 
		_i=0; 
	};
	}foreach toArray(_string);
	_hash;
};
MAP_INIT={[[],[]];};
MAP_SET={ 
	params["_ar","_k","_v"];
	private["_indexK","_cn"];
	_indexK=(_ar select 0) find _k;
	if(_indexK==-1)then{
		_cn=count (_ar select 0);
		(_ar select 0) set [_cn,_k];
		_indexK=_cn;
	};
	(_ar select 1) set [_indexK,_v];
	_ar;
}; 
MAP_GET={ 
	params["_ar","_k","_default"];
	private["_indexK","_res"];
	_indexK=(_ar select 0) find _k; 
	if(_indexK==-1)then{ 
		_res=_default;
	}else{ 
		_res=(_ar select 1) select _indexK; 
	}; 
	_res; 
};


JIVersion="0.5a";

scoreArr=[];
maxLvl=10;
currentLvl=0;
eAlive=0;
eJetsAlive=0;
repairEvery=5;
lvlEvery=10;
epos=getMarkerPos "eSpawn";//spawn some e
setViewDistance 5000;
FPS=0;
respawnDelay=15;
lameRearmDelay=20;
secondsBeforeDespawn=10;

if (isServer) then {
	private["_handle"];
	_handle = execVM "scripts\server.sqf";
	waitUntil {isNull _handle};
	_handle=nil;
};
if (!isDedicated) then {
    execVM "scripts\client.sqf";
};



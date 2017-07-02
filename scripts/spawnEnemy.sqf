private ["_e","_lvl2num","_lvl2skill","_lvl2vtype","_unitPack","_stack","_t","_v"];

_lvl2num= [10,15,15,20,20,20,20,20,20,25];
_lvl2jets=[1, 2, 3, 4, 5, 5, 5, 5, 5, 10];

_spawnN=_lvl2num select currentLvl;

_lvl2skill=[.4,.5,.5,.5,.5,.5,.5,.8,1,1];
_eSkill=_lvl2skill select currentLvl;
_skills=["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];

_lvl2vtypeShort=[
	[
		["I_Plane_Fighter_03_CAS_F"],
		["C_Heli_Light_01_civil_F","I_Heli_Transport_02_F","O_Heli_Light_02_F"],
		["O_Truck_02_covered_F","O_MRAP_02_F","O_MRAP_02_hmg_F"]
	],
	[
		["I_Plane_Fighter_03_CAS_F"],
		["I_Heli_Transport_02_F","I_Heli_light_03_F","O_Heli_Light_02_F"],
		["O_Truck_03_covered_F","O_Truck_03_fuel_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"]
	],
	[
		["I_Plane_Fighter_03_CAS_F"],
		["I_Heli_light_03_F"],
		["O_MRAP_02_hmg_F"]
	],
	[
		["I_Plane_Fighter_03_AA_F"],
		["O_Heli_Light_02_F","I_Heli_light_03_F"],
		["O_MBT_02_arty_F","I_MBT_03_cannon_F"]
	],
	[
		["O_Plane_CAS_02_F","I_Plane_Fighter_03_AA_F"],
		["I_Heli_light_03_F","O_Heli_Attack_02_black_F"],
		["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","I_MBT_03_cannon_F"]
	]
];

_lvl2vtype=[
	_lvl2vtypeShort select 0,_lvl2vtypeShort select 0,
	_lvl2vtypeShort select 1,_lvl2vtypeShort select 1,
	_lvl2vtypeShort select 2,_lvl2vtypeShort select 2,
	_lvl2vtypeShort select 3,_lvl2vtypeShort select 3,
	_lvl2vtypeShort select 4,_lvl2vtypeShort select 4
];
_unitPack=_lvl2vtype select currentLvl;

_setSkill={
	params['_crew','_skill'];
	private['_nerfK','_cr'];
	_nerfK=0.6;
	{
		_cr=_x;
		{
			_cr setSkill[_x,_skill];
		}foreach _skills;

		//nerf
		_cr setSkill["aimingAccuracy",_skill*_nerfK];
		_cr setSkill["aimingShake",_skill*_nerfK];
		_cr setSkill["aimingSpeed",_skill*_nerfK];
		_cr setSkill["spotDistance",_skill*_nerfK];
		_cr setSkill["spotTime",_skill*_nerfK];
	}foreach _crew;
};

_setWaypoints={
	private["_gr","_wp"];
	_gr=group driver (_this select 0);
	for "_i" from 1 to random[3,5,6] do {
		_wp = _gr addWaypoint [epos, 1000];
		_wp setWaypointBehaviour "COMBAT";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointType "SAD";
	};
	_wp = _gr addWaypoint [epos, 1000];
	_wp setWaypointType "CYCLE";
};

while {eAlive<_spawnN} do {
	_t=floor (random 3);
	if (_t!=0 or (_lvl2jets select currentLvl) > eJetsAlive) then {
		_stack=_unitPack select _t;
		_c=count _stack;
		if (_c>0) then {
			_vt=selectRandom _stack;
			if (_t==0) then [{_tr=eJetsSpawnTr;},{_tr=eSpawnTr;}];
			_pos=[[eSpawnTr],["water","out"],{true}] call BIS_fnc_randomPos;
			_pos=[_pos select 0,_pos select 1];
		
			_vTmp=[_pos, 180, _vt, OPFOR] call bis_fnc_spawnvehicle;
			_v=_vTmp select 0;
			_crew=_vTmp select 1;_vTmp = nil;

			if("O_APC_Tracked_02_AA_F"==_vt) then {//remove rockets from aa
				_v removeWeaponGlobal "missiles_titan";
			};
			if("I_Plane_Fighter_03_CAS_F"==_vt) then {//remove rockets from buzzard
				_v removeWeaponGlobal "missiles_ASRAAM";
			};
			if("O_Plane_CAS_02_F"==_vt && currentLvl<9) then {//remove rockets from neophron
				//_v removeWeaponGlobal "Missile_AA_03_Plane_CAS_02_F";
				;
			};

			[_crew,_eSkill] call _setSkill;
			[_v,_t] call handleKilled;
			[_v] call _setWaypoints;
			eAlive=eAlive+1;
			publicVariable "eAlive";
			if (_t==0) then {eJetsAlive=eJetsAlive+1;publicVariable "eJetsAlive";};
		}
	}
};



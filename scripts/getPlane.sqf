//Spawn a plane for user

params["_setpos"];
private["_upos","_height","_lvl","_vd","_dir","_speed","_planeLvl","_up","_up2"];

if (_setpos) then{
	_upos=getMarkerPos (selectRandom ["respawn_querilla0","respawn_querilla1","respawn_querilla2","respawn_querilla3"]);
}else{
	_upos=getPos player;
};

_height=500;
_upos=_upos vectorAdd [0,0,_height];


_up=[// ammoName, clipSize, gunName, maxAmmo, give, perXkills 
	["I_Plane_Fighter_03_AA_F",//buzzard aa
		[
			["120Rnd_CMFlare_Chaff_Magazine",120,"CMFlareLauncher",120,24,1],
			["300Rnd_20mm_shells",300,"Twin_Cannon_20mm",600,70,1],
			["2Rnd_AAA_missiles",2,"missiles_ASRAAM",2,1,2],
			["4Rnd_GAA_missiles",4,"missiles_Zephyr",4,1,4]
		]
	],
	["I_Plane_Fighter_03_CAS_F",//buzzard cas
		[
			["120Rnd_CMFlare_Chaff_Magazine",120,"CMFlareLauncher",120,24,1],
			["300Rnd_20mm_shells",300,"Twin_Cannon_20mm",300,70,1],
			["2Rnd_AAA_missiles",2,"missiles_ASRAAM",2,1,2],
			["2Rnd_LG_scalpel",2,"missiles_SCALPEL",2,1,4],
			["2Rnd_GBU12_LGB_MI10",2,"GBU12BombLauncher_Plane_Fighter_03_F",2,1,3]
		]
	],
	["O_Plane_CAS_02_F",//neofron
		[
			["120Rnd_CMFlare_Chaff_Magazine",120,"CMFlareLauncher",120,24,1],
			["500Rnd_Cannon_30mm_Plane_CAS_02_F",500,"Cannon_30mm_Plane_CAS_02_F",500,70,1],
			["2Rnd_Missile_AA_03_F",2,"Missile_AA_03_Plane_CAS_02_F",2,1,2],
			["4Rnd_Missile_AGM_01_F",4,"Missile_AGM_01_Plane_CAS_02_F",4,1,4],
			["2Rnd_Bomb_03_F",2,"Bomb_03_Plane_CAS_02_F",2,1,3],
			["20Rnd_Rocket_03_HE_F",20,"Rocket_03_HE_Plane_CAS_02_F",20,5,3],
			["20Rnd_Rocket_03_AP_F",20,"Rocket_03_AP_Plane_CAS_02_F",20,5,3]
		]
	],
	["B_Plane_CAS_01_F",//wipeout
		[
			["120Rnd_CMFlare_Chaff_Magazine",120,"CMFlareLauncher",120,48,1],
			["1000Rnd_Gatling_30mm_Plane_CAS_01_F",1000,"Gatling_30mm_Plane_CAS_01_F",1000,100,1],
			["2Rnd_Missile_AA_04_F",2,"Missile_AA_04_Plane_CAS_01_F",2,1,2],
			["6Rnd_Missile_AGM_02_F",6,"Missile_AGM_02_Plane_CAS_01_F",6,1,3],
			["4Rnd_Bomb_04_F",4,"Bomb_04_Plane_CAS_01_F",4,1,2],
			["7Rnd_Rocket_04_HE_F",7,"Rocket_04_HE_Plane_CAS_01_F",7,3,2],
			["7Rnd_Rocket_04_AP_F",7,"Rocket_04_AP_Plane_CAS_01_F",7,3,2]
		]
	]
];

_up2=[// ammoName, clipSize, gunName, maxAmmo, give, perXkills 
	["I_Plane_Fighter_03_AA_F",//buzzard aa
		[
			["120Rnd_CMFlare_Chaff_Magazine",120,"CMFlareLauncher",120,24,1],
			["300Rnd_20mm_shells",300,"Twin_Cannon_20mm",600,70,1],
			["2Rnd_AAA_missiles",2,"missiles_ASRAAM",2,1,2],
			["4Rnd_GAA_missiles",4,"missiles_Zephyr",4,1,4]
		]
	],
	["I_Plane_Fighter_04_F",//gryphon
		[
			["240Rnd_CMFlare_Chaff_Magazine",240,"CMFlareLauncher",240,24,1],
			["magazine_Fighter04_Gun20mm_AA_x250",150,"weapon_Fighter_Gun20mm_AA",150,70,1],
			["PylonMissile_Missile_BIM9x_x1",1,"weapon_BIM9xLauncher",2,1,2],
			["PylonMissile_Missile_AGM_02_x1",1,"weapon_AGM65Launcher",2,1,4],
			["PylonMissile_Missile_AMRAAM_C_x1",1,"weapon_AMRAAMLauncher",2,1,3]
		]
	],
	["O_Plane_Fighter_02_F",//shikra
		[
			["240Rnd_CMFlare_Chaff_Magazine",240,"CMFlareLauncher",240,24,1],
			["magazine_Fighter02_Gun30mm_AA_x180",180,"weapon_Fighter_Gun30mm",180,70,1],
			["PylonMissile_Missile_AA_R73_x1",1,"weapon_R73Launcher",4,1,4],
			["PylonMissile_Missile_AA_R77_x1",1,"weapon_R77Launcher",6,1,3],
			["PylonMissile_Bomb_KAB250_x1",1,"weapon_KAB250Launcher",2,1,2]
		]
	],
	["B_Plane_Fighter_01_F",//wasp
		[
			["240Rnd_CMFlare_Chaff_Magazine",240,"CMFlareLauncher",240,24,1],
			["magazine_Fighter01_Gun20mm_AA_x450",450,"weapon_Fighter_Gun20mm_AA",450,70,1],
			["PylonRack_Missile_AMRAAM_D_x1",1,"weapon_AMRAAMLauncher",4,1,3],
			["PylonRack_Missile_AGM_02_x2",2,"weapon_AGM65Launcher",4,1,3],
			["PylonMissile_Missile_BIM9x_x1",1,"weapon_BIM9xLauncher",2,1,2],
			["PylonMissile_Bomb_GBU12_x1",1,"weapon_GBU12Launcher",2,1,2]
		]
	]
];

_up=_up2;

userPlanes=[
	//_up select 0,
	_up select 1,
	_up select 1,
	_up select 2,
	_up select 2,
	_up select 2,
	_up select 3,
	_up select 3,
	_up select 3,
	_up select 3,
	_up select 3
];

if((vehicle player)!=player)then{
	moveOut player;
	plane=nil;
};
_lvl=player getVariable["lvl",0];
_planeLvl=currentLvl;
if(_lvl>_planeLvl) then {
	_planeLvl=_lvl;
};
player setVariable["planeLvl",_planeLvl,true];

if(_lvl>=10)exitWith{};
plane=createVehicle[(userPlanes select _planeLvl) select 0,_upos,[],300,"FLY"];

_speed=120;

_vd=epos vectorDiff _upos;
_dir=(_vd select 0) atan2 (_vd select 1); //_dir range from -180 to +180 
if(_dir < 0) then {_dir = 360 + _dir}; //_dir range from 0 to 360

plane setDir _dir;
plane setVelocity [(sin _dir)*_speed,(cos _dir)*_speed,0];

if (_lvl>=9) then {
	plane setObjectTextureGlobal [1,"#(rgb,8,8,3)color(0.3,0,0,1)"];
};

[player,plane] spawn {
	params["_plr","_pln"];
	private["_lim"];
	_lim=0;
	while {(vehicle _plr)==_plr && _lim<5} do{
		_plr moveInDriver _pln;
		_lim=_lim+1;
		sleep 0.5;
	};
};

rearmPlane={
	params["_kills","_msg"];
	private ["_aN", "_aS", "_gN", "_mA", "_give", "_perK", "_ammoFound", "_nm", "_cn", "_sN","_planeLvl","_key","_currentAmmo","_current"];
	_planeLvl=player getVariable["planeLvl",0];
	_currentAmmo=[] call MAP_INIT;
	{
		_nm=_x select 0;
		_cn=_x select 1;
		_key=toLower(_nm) call HASH;
		systemChat format["%1:%2",_nm,_key];
		_current=[_currentAmmo,_key,0] call MAP_GET;
		_current=_current+_cn;
		_currentAmmo=[_currentAmmo,_key,_current] call MAP_SET;
	}foreach magazinesAmmo vehicle player;
	//systemChat format["%1",_currentAmmo select 0];
	//systemChat format["%1",_currentAmmo select 1];
	{
		_aN=_x select 0;//ammo name
		_aS=_x select 1;//clip size
		_gN=_x select 2;//gun name
		_mA=_x select 3;//max ammo
		_give=_x select 4;//give amount
		_perK=_x select 5;//per kills
		
		_key=toLower(_aN) call HASH;

		systemChat format["%1:%2",_aN,_key];

		_current=[_currentAmmo,_key,0] call MAP_GET;

		if(floor(_kills/_perK)==(_kills/_perK))then{
			if(_current<_aS) then {
				//systemChat format["SET AMMO ammo: %4 gun: %3 cur: %1, set: %2",_current,_mA min (_current+_give),_gN,_aN];
				vehicle player setAmmo [_gN,_mA min (_current+_give)];
				_sN=(configFile >> "CfgWeapons" >> _gN >> "displayName") call BIS_fnc_getCfgData;
				if(isNil "_sN")then{
					_sN="=no weapon name in config=";
				};
				_msg=_msg+format["%1 for %2 added<br />",_give,_sN];
			};
		};
	}foreach ((userPlanes select _planeLvl) select 1);
	_msg;
};

repairPlane={
	params["_kills","_msg"];
	if(floor(_kills/repairEvery)==(_kills/repairEvery))then{
		vehicle player setdammage 0;
		vehicle player setfuel 1;
		player setDamage 0;
		_msg=_msg+"Repaired and refueled<br />";
	};
	_msg;
};



plane;

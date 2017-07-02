if (isDedicated) then {skipBrDisp=53} else {skipBrDisp=52}; 
if (hasInterface) then {
	if (!isNumber (missionConfigFile >> 'briefing')) exitWith {};
	if (getNumber (missionConfigFile >> 'briefing') == 1) exitWith {};
	0 = [] spawn {
		waitUntil {
			if (getClientState == "BRIEFING READ") exitWith {true};
			if (!isNull (findDisplay skipBrDisp)) exitWith {
				ctrlActivate ((findDisplay skipBrDisp) displayCtrl 1);
				(findDisplay skipBrDisp) closeDisplay 1;
				true;
			};
			false;
		};
	};
};
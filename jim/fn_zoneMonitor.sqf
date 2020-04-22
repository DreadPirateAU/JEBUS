while {alive player} do {
	sleep 1;
	
	_nearbyZones = player nearObjects["Sign_Arrow_Yellow_F", 400];
	{
		_status = _x getVariable ["Active", true];
		if (!_status) then {
			hint "Activate"; 
			[_x] remoteExec ["jim_fnc_zoneActivate"];
		};
	}forEach _nearbyZones;
};

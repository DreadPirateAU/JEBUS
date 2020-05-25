while {alive player} do {
	sleep 1;
	if (speed player < 100) then {
		_nearbyZones = nearestObjects[player, ["Sign_Arrow_Yellow_F"], 500, true];
		{
			_status = _x getVariable ["Active", true];
			if (!_status) then {
				[_x] remoteExec ["jim_fnc_zoneActivate"];
				sleep 0.1;
			};
		}forEach _nearbyZones;
		};
};
